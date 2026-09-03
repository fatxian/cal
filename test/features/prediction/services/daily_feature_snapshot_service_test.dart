import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';

void main() {
  const firstFeatures = DailyCalendarFeatures(
    totalEventCount: 3,
    allDayEventCount: 1,
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
  const updatedFeatures = DailyCalendarFeatures(
    totalEventCount: 4,
    allDayEventCount: 1,
    totalScheduledMinutes: 240,
    busyMinutes: 240,
    focusMinutes: 180,
    socialMinutes: 60,
    lifeAdminMinutes: 0,
    exerciseMinutes: 0,
    restMinutes: 0,
    backToBackEventCount: 2,
    freeMinutes: 600,
    longestGapBetweenActivitiesMinutes: 240,
    maxConsecutiveBlockMinutes: 180,
    freeSlots: [],
  );

  test('keeps first snapshot', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final service = DailyFeatureSnapshotService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 26);
    final capturedAt = DateTime(2026, 6, 26, 8, 30);

    final created = await service.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: firstFeatures,
      calendarSnapshotKey: 'first-calendar-state',
      analysisStartHour: 8,
      analysisEndHour: 22,
      capturedAt: capturedAt,
    );
    final createdAgain = await service.createInitialPredictionSnapshotIfAbsent(
      day: day,
      features: updatedFeatures,
      calendarSnapshotKey: 'updated-calendar-state',
      analysisStartHour: 8,
      analysisEndHour: 22,
      capturedAt: DateTime(2026, 6, 26, 12),
    );
    final snapshot = await service.loadInitialPredictionSnapshotForDay(day);

    expect(created, isTrue);
    expect(createdAgain, isFalse);
    expect(snapshot, isNotNull);
    expect(snapshot!.capturedAt, capturedAt);
    expect(snapshot.predictionPhase, 'initial');
    expect(snapshot.calendarSnapshotKey, 'first-calendar-state');
    expect(snapshot.features.totalScheduledMinutes, 180);
  });

  test('prevents duplicate snapshots', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final service = DailyFeatureSnapshotService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 27);

    final results = await Future.wait([
      service.createInitialPredictionSnapshotIfAbsent(
        day: day,
        features: firstFeatures,
        calendarSnapshotKey: 'first-calendar-state',
        analysisStartHour: 8,
        analysisEndHour: 22,
      ),
      service.createInitialPredictionSnapshotIfAbsent(
        day: day,
        features: updatedFeatures,
        calendarSnapshotKey: 'updated-calendar-state',
        analysisStartHour: 8,
        analysisEndHour: 22,
      ),
    ]);

    expect(results.where((created) => created), hasLength(1));
    expect(
      await database.select(database.dailyFeatureSnapshotItems).get(),
      hasLength(1),
    );
  });
}
