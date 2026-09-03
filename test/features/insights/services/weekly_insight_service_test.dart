import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/check_in/models/daily_reflection.dart';
import 'package:calendar_app/features/check_in/services/daily_reflection_service.dart';
import 'package:calendar_app/features/insights/services/weekly_insight_service.dart';
import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';

void main() {
  test('builds weekly insights', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final reflectionService = DailyReflectionService(database: database);
    final intentionService = DailyIntentionService(database: database);
    final weeklyInsightService = WeeklyInsightService(database: database);
    addTearDown(database.close);

    await reflectionService.saveReflectionForDay(
      DateTime(2026, 7, 13),
      const DailyReflection(
        energyScore: 2,
        intentionCompletionScore: 3,
        intentionHelpfulnessScore: 3,
      ),
    );
    await reflectionService.saveReflectionForDay(
      DateTime(2026, 7, 14),
      const DailyReflection(
        energyScore: 4,
        intentionCompletionScore: 2,
        intentionHelpfulnessScore: 2,
      ),
    );
    await intentionService.saveIntentionForDay(
      DateTime(2026, 7, 13),
      const DailyIntention(
        factor: ForecastFactor(
          type: ForecastFactorType.focusTime,
          label: 'Focused activities',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.quietPause,
          label: 'Take a quiet pause',
        ),
        calendarSnapshotKey: 'snapshot-1',
      ),
    );
    await intentionService.saveIntentionForDay(
      DateTime(2026, 7, 14),
      const DailyIntention(
        factor: ForecastFactor(
          type: ForecastFactorType.exercise,
          label: 'Exercise time',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.noChange,
          label: 'No change today',
        ),
        calendarSnapshotKey: 'snapshot-2',
      ),
    );

    final summary = await weeklyInsightService.loadSummaryForWeek(
      DateTime(2026, 7, 13),
    );

    expect(summary.weekStart, DateTime(2026, 7, 13));
    expect(summary.energyDays.map((day) => day.energyScore), [
      2,
      4,
      null,
      null,
      null,
      null,
      null,
    ]);
    expect(summary.reflectionCount, 2);
    expect(summary.lowEnergyCount, 1);
    expect(summary.averageEnergy, 3);
    expect(summary.previousAverageEnergy, isNull);
    expect(summary.sections, hasLength(3));
    expect(summary.activityEnergySummaries, isEmpty);
    expect(summary.forecastComparison.comparedDayCount, 0);
    expect(summary.sections[0].isLocked, isTrue);
    expect(summary.sections[0].title, 'Cal saw a pattern this week');
    expect(
      summary.sections[0].body,
      'Keep completing forecasts and reflections to reveal your first '
      'pattern.',
    );
    expect(summary.intentionSummaries, hasLength(1));
    expect(summary.intentionSummaries.first.label, 'Take a quiet pause');
    expect(summary.intentionSummaries.first.setCount, 1);
    expect(summary.intentionSummaries.first.completedCount, 1);
    expect(summary.intentionSummaries.first.increasedCount, 1);
    expect(summary.sections[1].isLocked, isFalse);
    expect(
      summary.sections[2].body,
      contains('Complete the initial questionnaire'),
    );
    expect(summary.sections[2].isLocked, isTrue);
  });
}
