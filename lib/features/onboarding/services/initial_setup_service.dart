import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../prediction/services/energy_model_service.dart';
import '../../prediction/services/questionnaire_model_initializer.dart';
import '../models/onboarding_questionnaire_answers.dart';

enum InitialSetupStep {
  introduction,
  questionnaire,
  calendarConnection,
  complete,
}

class InitialSetupService {
  const InitialSetupService({
    required this.database,
    this.energyModelService,
    this.questionnaireModelInitializer = const QuestionnaireModelInitializer(),
  });

  static const int setupRowId = 1;
  static const String questionnaireVersion = 'energy_onboarding_v2';

  final AppDatabase database;
  final EnergyModelService? energyModelService;
  final QuestionnaireModelInitializer questionnaireModelInitializer;

  Future<InitialSetupStep> loadCurrentStep() async {
    final row = await _loadSetupRow();

    if (row == null) {
      return InitialSetupStep.introduction;
    }
    if (row.calendarSetupCompletedAt == null) {
      return InitialSetupStep.calendarConnection;
    }

    return InitialSetupStep.complete;
  }

  Future<OnboardingQuestionnaireAnswers?> loadQuestionnaireAnswers() async {
    final row = await _loadSetupRow();
    if (row == null) return null;

    return OnboardingQuestionnaireAnswers(
      typicalEnergyScore: row.typicalEnergyScore,
      busyImpactScore: row.busyImpactScore,
      backToBackImpactScore: row.backToBackImpactScore,
      longBlockImpactScore: row.longBlockImpactScore,
      freeGapImpactScore: row.freeGapImpactScore,
      focusImpactScore: row.focusImpactScore,
      socialImpactScore: row.socialImpactScore,
      lifeAdminImpactScore: row.lifeAdminImpactScore,
      exerciseImpactScore: row.exerciseImpactScore,
      calendarUnderstandingScore: row.calendarUnderstandingScore,
      schedulePredictionConfidenceScore: row.schedulePredictionConfidenceScore,
    );
  }

  Future<void> saveQuestionnaireAnswers(
    OnboardingQuestionnaireAnswers answers,
  ) async {
    final now = DateTime.now();
    final existingRow = await _loadSetupRow();

    await database.transaction(() async {
      await database
          .into(database.initialSetupItems)
          .insert(
            InitialSetupItemsCompanion.insert(
              id: const Value(setupRowId),
              researchParticipantCode: Value(
                existingRow?.researchParticipantCode,
              ),
              questionnaireVersion: questionnaireVersion,
              typicalEnergyScore: answers.typicalEnergyScore,
              busyImpactScore: answers.busyImpactScore,
              backToBackImpactScore: answers.backToBackImpactScore,
              longBlockImpactScore: answers.longBlockImpactScore,
              freeGapImpactScore: answers.freeGapImpactScore,
              focusImpactScore: answers.focusImpactScore,
              socialImpactScore: answers.socialImpactScore,
              lifeAdminImpactScore: answers.lifeAdminImpactScore,
              exerciseImpactScore: answers.exerciseImpactScore,
              calendarUnderstandingScore: answers.calendarUnderstandingScore,
              schedulePredictionConfidenceScore:
                  answers.schedulePredictionConfidenceScore,
              questionnaireCompletedAt:
                  existingRow?.questionnaireCompletedAt ?? now,
              calendarSetupCompletedAt: Value(
                existingRow?.calendarSetupCompletedAt,
              ),
              calendarSetupSkipped: Value(
                existingRow?.calendarSetupSkipped ?? false,
              ),
              updatedAt: Value(now),
            ),
            mode: InsertMode.insertOrReplace,
          );

      await energyModelService?.saveActiveModel(
        parameters: questionnaireModelInitializer.createInitialModel(answers),
        modelSource: EnergyModelSource.questionnaireBaseline,
        savedAt: now,
      );
    });
  }

  Future<void> completeCalendarSetup({required bool skipped}) async {
    final updatedRows =
        await (database.update(
          database.initialSetupItems,
        )..where((table) => table.id.equals(setupRowId))).write(
          InitialSetupItemsCompanion(
            calendarSetupCompletedAt: Value(DateTime.now()),
            calendarSetupSkipped: Value(skipped),
            updatedAt: Value(DateTime.now()),
          ),
        );

    if (updatedRows == 0) {
      throw StateError('Questionnaire must be completed first.');
    }
  }

  Future<InitialSetupItem?> _loadSetupRow() {
    return (database.select(
      database.initialSetupItems,
    )..where((table) => table.id.equals(setupRowId))).getSingleOrNull();
  }
}
