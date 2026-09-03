import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/check_in/models/daily_reflection.dart';
import 'package:calendar_app/features/check_in/services/daily_reflection_service.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/daily_prediction.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/models/model_update_result.dart';
import 'package:calendar_app/features/prediction/services/batch_logistic_trainer.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';
import 'package:calendar_app/features/prediction/services/personalised_model_update_service.dart';
import 'package:calendar_app/features/prediction/services/prediction_dataset_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DailyFeatureSnapshotService snapshotService;
  late DailyPredictionRecordService predictionRecordService;
  late DailyReflectionService reflectionService;
  late EnergyModelService energyModelService;
  late PersonalisedModelUpdateService updateService;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    snapshotService = DailyFeatureSnapshotService(database: database);
    predictionRecordService = DailyPredictionRecordService(database: database);
    reflectionService = DailyReflectionService(database: database);
    energyModelService = EnergyModelService(database: database);
    updateService = PersonalisedModelUpdateService(
      datasetService: PredictionDatasetService(database: database),
      energyModelService: energyModelService,
      trainer: const BatchLogisticTrainer(iterations: 200),
    );
  });

  tearDown(() => database.close());

  test('waits for seven samples', () async {
    await _seedSamples(
      count: 6,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      reflectionService: reflectionService,
    );

    final result = await updateService.updateModelIfReady();

    expect(result.status, ModelUpdateStatus.notEnoughSamples);
    expect(result.sampleCount, 6);
    expect(result.didUpdate, isFalse);
    expect(await energyModelService.loadActiveModel(), isNull);
  });

  test('requires both classes', () async {
    await _seedSamples(
      count: 7,
      lowEnergyOnly: true,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      reflectionService: reflectionService,
    );

    final result = await updateService.updateModelIfReady();

    expect(result.status, ModelUpdateStatus.missingClassBalance);
    expect(result.sampleCount, 7);
    expect(result.didUpdate, isFalse);
  });

  test('saves personalised model', () async {
    await energyModelService.saveActiveModel(
      parameters: _baselineModel(),
      modelSource: EnergyModelSource.questionnaireBaseline,
      savedAt: DateTime(2026, 7, 1),
    );
    await _seedSamples(
      count: 8,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      reflectionService: reflectionService,
    );

    final result = await updateService.updateModelIfReady(
      updatedAt: DateTime(2026, 7, 9),
    );
    final activeModel = await energyModelService.loadActiveModel();
    final rows = await database.select(database.energyModelItems).get();

    expect(result.status, ModelUpdateStatus.updated);
    expect(result.sampleCount, 8);
    expect(result.didUpdate, isTrue);
    expect(activeModel!.modelVersion, 'personalised-logistic-v2');
    expect(
      activeModel.coefficientFor(EnergyModelFeature.busyMinutes),
      isPositive,
    );
    expect(rows.where((row) => row.isActive), hasLength(1));
    expect(rows.last.modelSource, EnergyModelSource.personalisedLogistic);
  });
}

Future<void> _seedSamples({
  required int count,
  bool lowEnergyOnly = false,
  required DailyFeatureSnapshotService snapshotService,
  required DailyPredictionRecordService predictionRecordService,
  required DailyReflectionService reflectionService,
}) async {
  for (var index = 0; index < count; index++) {
    final day = DateTime(2026, 7, index + 1);
    final isLowEnergy = lowEnergyOnly || index < count / 2;
    final busyMinutes = isLowEnergy ? 480 : 30;
    final energyScore = isLowEnergy ? 2 : 4;

    await snapshotService.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: _features(busyMinutes: busyMinutes),
      calendarSnapshotKey: 'snapshot-$index',
      analysisStartHour: 8,
      analysisEndHour: 22,
      capturedAt: DateTime(2026, 7, index + 1, 9),
    );
    final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
      day,
    );

    await predictionRecordService.createInitialPredictionIfAbsent(
      day: day,
      featureSnapshotId: snapshot!.id,
      predictedCategory: DailyPredictionCategory.low,
      predictedScore: 0.5,
      reasons: const ['Test reason'],
      predictionVersion: 'questionnaire-baseline-v1',
    );
    await reflectionService.saveReflectionForDay(
      day,
      DailyReflection(energyScore: energyScore),
    );
  }
}

DailyCalendarFeatures _features({required int busyMinutes}) {
  return DailyCalendarFeatures(
    totalEventCount: busyMinutes == 0 ? 0 : 1,
    allDayEventCount: 0,
    totalScheduledMinutes: busyMinutes,
    busyMinutes: busyMinutes,
    focusMinutes: 0,
    socialMinutes: 0,
    lifeAdminMinutes: 0,
    exerciseMinutes: 0,
    restMinutes: 0,
    backToBackEventCount: 0,
    freeMinutes: 840 - busyMinutes,
    longestGapBetweenActivitiesMinutes: 180,
    maxConsecutiveBlockMinutes: busyMinutes,
    freeSlots: const [],
  );
}

LogisticModelParameters _baselineModel() {
  return LogisticModelParameters(
    featureVersion: EnergyModelContract.featureVersion,
    targetVersion: EnergyModelContract.targetVersion,
    modelVersion: 'questionnaire-baseline-v1',
    intercept: 0,
    coefficients: {
      for (final feature in EnergyModelContract.orderedFeatures) feature: 0,
    },
  );
}
