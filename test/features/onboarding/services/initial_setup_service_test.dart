import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/onboarding/models/onboarding_questionnaire_answers.dart';
import 'package:calendar_app/features/onboarding/services/initial_setup_service.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late EnergyModelService energyModelService;
  late InitialSetupService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    energyModelService = EnergyModelService(database: database);
    service = InitialSetupService(
      database: database,
      energyModelService: energyModelService,
    );
  });

  tearDown(() => database.close());

  test('completes initial setup', () async {
    expect(await service.loadCurrentStep(), InitialSetupStep.introduction);

    await service.saveQuestionnaireAnswers(_answers);

    expect(
      await service.loadCurrentStep(),
      InitialSetupStep.calendarConnection,
    );
    expect(
      await service.loadQuestionnaireAnswers(),
      isA<OnboardingQuestionnaireAnswers>()
          .having((answers) => answers.typicalEnergyScore, 'baseline', 4)
          .having((answers) => answers.busyImpactScore, 'busy impact', 2),
    );
    expect(
      (await energyModelService.loadActiveModel())!.targetVersion,
      EnergyModelContract.targetVersion,
    );
    expect(
      (await database.select(database.initialSetupItems).getSingle())
          .questionnaireVersion,
      'energy_onboarding_v2',
    );

    await service.completeCalendarSetup(skipped: false);

    expect(await service.loadCurrentStep(), InitialSetupStep.complete);

    await database
        .update(database.initialSetupItems)
        .write(
          const InitialSetupItemsCompanion(
            researchParticipantCode: Value('CAL-TEST000001'),
          ),
        );

    await service.saveQuestionnaireAnswers(_editedAnswers);

    expect(await service.loadCurrentStep(), InitialSetupStep.complete);
    expect((await service.loadQuestionnaireAnswers())!.busyImpactScore, 5);
    expect(
      (await database.select(database.initialSetupItems).getSingle())
          .researchParticipantCode,
      'CAL-TEST000001',
    );
    expect(
      (await energyModelService.loadActiveModel())!.coefficientFor(
        EnergyModelFeature.busyMinutes,
      ),
      -0.5,
    );
  });

  test('rolls back failed setup', () async {
    final failingService = InitialSetupService(
      database: database,
      energyModelService: _FailingEnergyModelService(database: database),
    );

    await expectLater(
      failingService.saveQuestionnaireAnswers(_answers),
      throwsStateError,
    );

    expect(
      await database.select(database.initialSetupItems).getSingleOrNull(),
      equals(null),
    );
  });
}

class _FailingEnergyModelService extends EnergyModelService {
  const _FailingEnergyModelService({required super.database});

  @override
  Future<void> saveActiveModel({
    required LogisticModelParameters parameters,
    required String modelSource,
    DateTime? savedAt,
  }) {
    throw StateError('Test model save failure');
  }
}

const _answers = OnboardingQuestionnaireAnswers(
  typicalEnergyScore: 4,
  busyImpactScore: 2,
  backToBackImpactScore: 1,
  longBlockImpactScore: 2,
  freeGapImpactScore: 5,
  focusImpactScore: 2,
  socialImpactScore: 4,
  lifeAdminImpactScore: 2,
  exerciseImpactScore: 5,
  calendarUnderstandingScore: 3,
  schedulePredictionConfidenceScore: 3,
);

const _editedAnswers = OnboardingQuestionnaireAnswers(
  typicalEnergyScore: 4,
  busyImpactScore: 5,
  backToBackImpactScore: 1,
  longBlockImpactScore: 2,
  freeGapImpactScore: 5,
  focusImpactScore: 2,
  socialImpactScore: 4,
  lifeAdminImpactScore: 2,
  exerciseImpactScore: 5,
  calendarUnderstandingScore: 3,
  schedulePredictionConfidenceScore: 3,
);
