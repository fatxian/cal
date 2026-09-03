import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/daily_calendar_features.dart';
import '../models/daily_feature_snapshot.dart';

class DailyFeatureSnapshotService {
  const DailyFeatureSnapshotService({required this.database});

  static const String initialPredictionPhase = 'initial';
  static const int calculationVersion = 2;

  final AppDatabase database;

  Future<bool> createInitialPredictionSnapshotIfAbsent({
    required DateTime day,
    required DailyCalendarFeatures features,
    required String calendarSnapshotKey,
    required int analysisStartHour,
    required int analysisEndHour,
    DateTime? capturedAt,
  }) async {
    final timestamp = capturedAt ?? DateTime.now();
    final date = dateKey(day);

    // preserve the features used for the day's initial forecast so later
    // calendar edits do not change the observation used for training
    // use one transaction so concurrent requests cannot create duplicates
    return database.transaction(() async {
      final existingSnapshot = await (database.select(
        database.dailyFeatureSnapshotItems,
      )..where((table) => table.date.equals(date))).getSingleOrNull();

      if (existingSnapshot != null) return false;

      await database
          .into(database.dailyFeatureSnapshotItems)
          .insert(
            DailyFeatureSnapshotItemsCompanion.insert(
              date: date,
              capturedAt: timestamp,
              analysisStartHour: analysisStartHour,
              analysisEndHour: analysisEndHour,
              predictionPhase: initialPredictionPhase,
              calculationVersion: calculationVersion,
              calendarSnapshotKey: calendarSnapshotKey,
              totalEventCount: features.totalEventCount,
              allDayEventCount: features.allDayEventCount,
              totalScheduledMinutes: features.totalScheduledMinutes,
              busyMinutes: features.busyMinutes,
              focusMinutes: features.focusMinutes,
              socialMinutes: features.socialMinutes,
              lifeAdminMinutes: features.lifeAdminMinutes,
              exerciseMinutes: features.exerciseMinutes,
              restMinutes: features.restMinutes,
              backToBackEventCount: features.backToBackEventCount,
              freeMinutes: features.freeMinutes,
              longestGapBetweenActivitiesMinutes:
                  features.longestGapBetweenActivitiesMinutes,
              maxConsecutiveBlockMinutes: features.maxConsecutiveBlockMinutes,
              createdAt: Value(timestamp),
              updatedAt: Value(timestamp),
            ),
          );

      return true;
    });
  }

  Future<DailyFeatureSnapshot?> loadInitialPredictionSnapshotForDay(
    DateTime day,
  ) async {
    final row = await (database.select(
      database.dailyFeatureSnapshotItems,
    )..where((table) => table.date.equals(dateKey(day)))).getSingleOrNull();

    if (row == null) return null;

    return DailyFeatureSnapshot(
      id: row.id,
      day: DateTime.parse(row.date),
      capturedAt: row.capturedAt,
      analysisStartHour: row.analysisStartHour,
      analysisEndHour: row.analysisEndHour,
      predictionPhase: row.predictionPhase,
      calculationVersion: row.calculationVersion,
      calendarSnapshotKey: row.calendarSnapshotKey,
      features: DailyCalendarFeatures(
        totalEventCount: row.totalEventCount,
        allDayEventCount: row.allDayEventCount,
        totalScheduledMinutes: row.totalScheduledMinutes,
        busyMinutes: row.busyMinutes,
        focusMinutes: row.focusMinutes,
        socialMinutes: row.socialMinutes,
        lifeAdminMinutes: row.lifeAdminMinutes,
        exerciseMinutes: row.exerciseMinutes,
        restMinutes: row.restMinutes,
        backToBackEventCount: row.backToBackEventCount,
        freeMinutes: row.freeMinutes,
        longestGapBetweenActivitiesMinutes:
            row.longestGapBetweenActivitiesMinutes,
        maxConsecutiveBlockMinutes: row.maxConsecutiveBlockMinutes,
        freeSlots: const [],
      ),
    );
  }
}
