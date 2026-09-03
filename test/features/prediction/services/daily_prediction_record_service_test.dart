import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';

void main() {
  const features = DailyCalendarFeatures(
    totalEventCount: 3,
    allDayEventCount: 0,
    totalScheduledMinutes: 180,
    busyMinutes: 180,
    focusMinutes: 180,
    socialMinutes: 0,
    lifeAdminMinutes: 0,
    exerciseMinutes: 0,
    restMinutes: 0,
    backToBackEventCount: 1,
    freeMinutes: 660,
    longestGapBetweenActivitiesMinutes: 300,
    maxConsecutiveBlockMinutes: 120,
    freeSlots: [],
  );

  test('keeps first prediction', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final snapshotService = DailyFeatureSnapshotService(database: database);
    final predictionService = DailyPredictionRecordService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 28);

    await snapshotService.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: features,
      calendarSnapshotKey: 'initial-calendar-state',
      analysisStartHour: 8,
      analysisEndHour: 22,
      capturedAt: DateTime(2026, 6, 28, 13, 15),
    );
    final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
      day,
    );

    final created = await predictionService.createInitialPredictionIfAbsent(
      day: day,
      featureSnapshotId: snapshot!.id,
      predictedCategory: 'demanding',
      predictedScore: 0.72,
      reasons: ['Long consecutive block', 'Limited uninterrupted time'],
      predictionVersion: 'rule-v1',
      createdAt: DateTime(2026, 6, 28, 13, 15),
    );
    final createdAgain = await predictionService
        .createInitialPredictionIfAbsent(
          day: day,
          featureSnapshotId: snapshot.id,
          predictedCategory: 'lighter',
          predictedScore: 0.20,
          reasons: ['Updated reason'],
          predictionVersion: 'rule-v2',
          createdAt: DateTime(2026, 6, 28, 16),
        );
    final prediction = await predictionService.loadInitialPredictionForDay(day);
    final feedbackUpdatedAt = DateTime(2026, 6, 28, 17);

    await predictionService.saveAgreementForDay(
      day,
      1,
      updatedAt: feedbackUpdatedAt,
    );
    final predictionWithFeedback = await predictionService
        .loadInitialPredictionForDay(day);

    expect(created, isTrue);
    expect(createdAgain, isFalse);
    expect(prediction, isNotNull);
    expect(prediction!.featureSnapshotId, snapshot.id);
    expect(prediction.predictedCategory, 'demanding');
    expect(prediction.predictedScore, 0.72);
    expect(prediction.reasons, [
      'Long consecutive block',
      'Limited uninterrupted time',
    ]);
    expect(prediction.predictionVersion, 'rule-v1');
    expect(predictionWithFeedback!.agreementScore, 1);
    expect(predictionWithFeedback.feedbackUpdatedAt, feedbackUpdatedAt);
    expect(predictionService.saveAgreementForDay(day, 3), throwsArgumentError);
  });

  test('prevents duplicate predictions', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final snapshotService = DailyFeatureSnapshotService(database: database);
    final predictionService = DailyPredictionRecordService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 29);

    await snapshotService.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: features,
      calendarSnapshotKey: 'calendar-state',
      analysisStartHour: 8,
      analysisEndHour: 22,
    );
    final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
      day,
    );

    final results = await Future.wait([
      predictionService.createInitialPredictionIfAbsent(
        day: day,
        featureSnapshotId: snapshot!.id,
        predictedCategory: 'demanding',
        predictedScore: 0.72,
        reasons: const ['First request'],
        predictionVersion: 'logistic-v1',
      ),
      predictionService.createInitialPredictionIfAbsent(
        day: day,
        featureSnapshotId: snapshot.id,
        predictedCategory: 'lighter',
        predictedScore: 0.28,
        reasons: const ['Second request'],
        predictionVersion: 'logistic-v1',
      ),
    ]);

    expect(results.where((created) => created), hasLength(1));
    expect(
      await database.select(database.dailyPredictionItems).get(),
      hasLength(1),
    );
  });
}
