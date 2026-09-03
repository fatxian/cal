import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_service.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';

void main() {
  test('saves forecast expectations', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final reflectionService = ForecastReflectionService(database: database);
    final snapshotService = DailyFeatureSnapshotService(database: database);
    final predictionService = DailyPredictionRecordService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 7, 18);
    final revealedAt = DateTime(2026, 7, 18, 10, 30);

    await snapshotService.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: const DailyCalendarFeatures(
        totalEventCount: 1,
        allDayEventCount: 0,
        totalScheduledMinutes: 60,
        busyMinutes: 60,
        focusMinutes: 60,
        socialMinutes: 0,
        lifeAdminMinutes: 0,
        exerciseMinutes: 0,
        restMinutes: 0,
        backToBackEventCount: 0,
        freeMinutes: 780,
        longestGapBetweenActivitiesMinutes: 420,
        maxConsecutiveBlockMinutes: 60,
        freeSlots: [],
      ),
      calendarSnapshotKey: 'calendar-state',
      analysisStartHour: 8,
      analysisEndHour: 22,
      capturedAt: revealedAt,
    );
    final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
      day,
    );
    await predictionService.createInitialPredictionIfAbsent(
      day: day,
      featureSnapshotId: snapshot!.id,
      predictedCategory: 'sufficient',
      predictedScore: 0.42,
      reasons: const [],
      predictionVersion: 'questionnaire-baseline-v1',
      createdAt: revealedAt,
    );
    final prediction = await predictionService.loadInitialPredictionForDay(day);

    await reflectionService.saveReflectionForDay(
      day: day,
      predictionId: prediction!.id,
      supportiveFactor: const ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
      ),
      demandingFactor: const ForecastFactor(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
      ),
      modelSupportiveFactor: const ForecastFactor(
        type: ForecastFactorType.socialTime,
        label: 'Social activities',
      ),
      modelDemandingFactor: const ForecastFactor(
        type: ForecastFactorType.scheduledTime,
        label: 'Scheduled time',
      ),
      revealedAt: revealedAt,
    );
    final reflection = await reflectionService.loadReflectionForDay(day);

    expect(reflection, isNotNull);
    expect(reflection!.predictionId, prediction.id);
    expect(reflection.supportiveFactor.type, ForecastFactorType.exercise);
    expect(reflection.supportiveFactor.label, 'Exercise time');
    expect(reflection.demandingFactor.type, ForecastFactorType.focusTime);
    expect(reflection.demandingFactor.label, 'Focused activities');
    expect(
      reflection.modelSupportiveFactor?.type,
      ForecastFactorType.socialTime,
    );
    expect(reflection.modelSupportiveFactor?.label, 'Social activities');
    expect(
      reflection.modelDemandingFactor?.type,
      ForecastFactorType.scheduledTime,
    );
    expect(reflection.modelDemandingFactor?.label, 'Total scheduled time');
    expect(reflection.revealedAt, revealedAt);
  });
}
