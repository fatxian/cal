import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/check_in/models/daily_reflection.dart';
import 'package:calendar_app/features/check_in/services/daily_reflection_service.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/daily_prediction.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/prediction_dataset_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DailyFeatureSnapshotService snapshotService;
  late DailyPredictionRecordService predictionRecordService;
  late DailyReflectionService reflectionService;
  late PredictionDatasetService datasetService;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    snapshotService = DailyFeatureSnapshotService(database: database);
    predictionRecordService = DailyPredictionRecordService(database: database);
    reflectionService = DailyReflectionService(database: database);
    datasetService = PredictionDatasetService(database: database);
  });

  tearDown(() => database.close());

  test('loads training samples', () async {
    final day = DateTime(2026, 7, 1);
    final snapshotId = await _createSnapshotAndPrediction(
      day: day,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      features: _features(
        busyMinutes: 180,
        focusMinutes: 120,
        exerciseMinutes: 30,
        backToBackEventCount: 1,
      ),
    );
    await predictionRecordService.saveAgreementForDay(
      day,
      DailyPredictionAgreement.partly,
    );
    await reflectionService.saveReflectionForDay(
      day,
      const DailyReflection(
        energyScore: 2,
        intentionCompletionScore: 2,
        intentionHelpfulnessScore: 1,
      ),
    );

    final samples = await datasetService.loadCompletedSamples();

    expect(samples, hasLength(1));
    expect(await datasetService.countCompletedSamples(), 1);
    expect(samples.single.day, DateTime(2026, 7, 1));
    expect(samples.single.featureSnapshotId, snapshotId);
    expect(samples.single.features.busyMinutes, 180);
    expect(samples.single.features.focusMinutes, 120);
    expect(samples.single.features.exerciseMinutes, 30);
    expect(samples.single.features.backToBackEventCount, 1);
    expect(samples.single.energyScore, 2);
    expect(samples.single.lowEnergyLabel, 1);
    expect(samples.single.predictedScore, 0.62);
    expect(samples.single.predictionVersion, 'test-prediction-v1');
    expect(
      samples.single.predictionAgreementScore,
      DailyPredictionAgreement.partly,
    );
    expect(samples.single.intentionCompletionScore, 2);
    expect(samples.single.intentionHelpfulnessScore, 1);
  });

  test('skips incomplete dates', () async {
    final completeDay = DateTime(2026, 7, 1);
    final missingReflectionDay = DateTime(2026, 7, 2);
    final missingPredictionDay = DateTime(2026, 7, 3);

    await _createSnapshotAndPrediction(
      day: completeDay,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      features: _features(busyMinutes: 60),
    );
    await reflectionService.saveReflectionForDay(
      completeDay,
      const DailyReflection(energyScore: 4),
    );
    await _createSnapshotAndPrediction(
      day: missingReflectionDay,
      snapshotService: snapshotService,
      predictionRecordService: predictionRecordService,
      features: _features(busyMinutes: 120),
    );
    await snapshotService.createInitialPredictionSnapshotIfAbsent(
      day: missingPredictionDay,
      features: _features(busyMinutes: 240),
      calendarSnapshotKey: 'missing-prediction',
      analysisStartHour: 8,
      analysisEndHour: 22,
    );
    await reflectionService.saveReflectionForDay(
      missingPredictionDay,
      const DailyReflection(energyScore: 1),
    );

    final samples = await datasetService.loadCompletedSamples();

    expect(samples, hasLength(1));
    expect(samples.single.day, completeDay);
    expect(samples.single.energyScore, 4);
    expect(samples.single.lowEnergyLabel, 0);
  });
}

Future<int> _createSnapshotAndPrediction({
  required DateTime day,
  required DailyFeatureSnapshotService snapshotService,
  required DailyPredictionRecordService predictionRecordService,
  required DailyCalendarFeatures features,
}) async {
  await snapshotService.createInitialPredictionSnapshotIfAbsent(
    day: day,
    features: features,
    calendarSnapshotKey: 'calendar-${day.toIso8601String()}',
    analysisStartHour: 8,
    analysisEndHour: 22,
    capturedAt: DateTime(day.year, day.month, day.day, 9),
  );
  final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
    day,
  );

  await predictionRecordService.createInitialPredictionIfAbsent(
    day: day,
    featureSnapshotId: snapshot!.id,
    predictedCategory: DailyPredictionCategory.low,
    predictedScore: 0.62,
    reasons: const ['Test reason'],
    predictionVersion: 'test-prediction-v1',
    createdAt: DateTime(day.year, day.month, day.day, 9, 1),
  );

  return snapshot.id;
}

DailyCalendarFeatures _features({
  required int busyMinutes,
  int focusMinutes = 0,
  int socialMinutes = 0,
  int lifeAdminMinutes = 0,
  int exerciseMinutes = 0,
  int backToBackEventCount = 0,
}) {
  return DailyCalendarFeatures(
    totalEventCount: busyMinutes == 0 ? 0 : 1,
    allDayEventCount: 0,
    totalScheduledMinutes: busyMinutes,
    busyMinutes: busyMinutes,
    focusMinutes: focusMinutes,
    socialMinutes: socialMinutes,
    lifeAdminMinutes: lifeAdminMinutes,
    exerciseMinutes: exerciseMinutes,
    restMinutes: 0,
    backToBackEventCount: backToBackEventCount,
    freeMinutes: 840 - busyMinutes,
    longestGapBetweenActivitiesMinutes: 180,
    maxConsecutiveBlockMinutes: busyMinutes,
    freeSlots: const [],
  );
}
