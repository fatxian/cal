import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/weekly_insight_aggregate.dart';

class WeeklyEnergyIntentionAnalyzer {
  const WeeklyEnergyIntentionAnalyzer();

  WeeklyEnergyIntentionAnalysis build({
    required DateTime weekStart,
    required List<DailyReflectionItem> reflections,
    required List<DailyReflectionItem> previousReflections,
    required List<DailyIntentionItem> intentions,
  }) {
    final reflectionsByDate = {
      for (final reflection in reflections) reflection.date: reflection,
    };
    final intentionsByDate = {
      for (final intention in intentions) intention.date: intention,
    };
    final energyDays = <WeeklyEnergyRecord>[];
    final intentionCounts = <String, _MutableIntentionSummary>{};
    var lowEnergyCount = 0;
    var energyTotal = 0;
    var intentionCount = 0;

    for (var index = 0; index < 7; index++) {
      final day = weekStart.add(Duration(days: index));
      final date = dateKey(day);
      final reflection = reflectionsByDate[date];
      final intention = intentionsByDate[date];
      final hasActionableIntention =
          intention != null && intention.adjustmentType != 'noChange';

      energyDays.add(
        WeeklyEnergyRecord(date: day, energyScore: reflection?.energyScore),
      );
      if (reflection != null) {
        energyTotal += reflection.energyScore;
        if (reflection.energyScore <= 2) lowEnergyCount++;
      }
      if (!hasActionableIntention) continue;

      intentionCount++;
      final summary = intentionCounts.putIfAbsent(
        intention.adjustmentType,
        () => _MutableIntentionSummary(
          adjustmentType: intention.adjustmentType,
          exampleLabel: intention.selectedAdjustment,
        ),
      );
      summary.setCount++;

      if (reflection == null) continue;
      final completionScore = reflection.intentionCompletionScore;
      if (completionScore != null && completionScore >= 2) {
        summary.partlyOrFullyCompletedCount++;
      }

      final impactScore = reflection.intentionHelpfulnessScore;
      if (impactScore == null) continue;
      summary.reflectedCount++;
      if (impactScore == 1) {
        summary.decreasedCount++;
      } else if (impactScore == 2) {
        summary.unchangedCount++;
      } else if (impactScore == 3) {
        summary.increasedCount++;
      }
    }

    final intentionSummaries =
        intentionCounts.values.map((summary) => summary.build()).toList()
          ..sort((first, second) {
            final countComparison = second.setCount.compareTo(first.setCount);
            if (countComparison != 0) return countComparison;
            return first.adjustmentType.compareTo(second.adjustmentType);
          });

    return WeeklyEnergyIntentionAnalysis(
      energyDays: energyDays,
      reflectionCount: reflections.length,
      lowEnergyCount: lowEnergyCount,
      energyTotal: energyTotal,
      previousReflectionCount: previousReflections.length,
      previousEnergyTotal: previousReflections.fold(
        0,
        (total, reflection) => total + reflection.energyScore,
      ),
      intentionSummaries: intentionSummaries,
      intentionCount: intentionCount,
    );
  }
}

class WeeklyEnergyIntentionAnalysis {
  const WeeklyEnergyIntentionAnalysis({
    required this.energyDays,
    required this.reflectionCount,
    required this.lowEnergyCount,
    required this.energyTotal,
    required this.previousReflectionCount,
    required this.previousEnergyTotal,
    required this.intentionSummaries,
    required this.intentionCount,
  });

  final List<WeeklyEnergyRecord> energyDays;
  final int reflectionCount;
  final int lowEnergyCount;
  final int energyTotal;
  final int previousReflectionCount;
  final int previousEnergyTotal;
  final List<WeeklyIntentionSummary> intentionSummaries;
  final int intentionCount;
}

class _MutableIntentionSummary {
  _MutableIntentionSummary({
    required this.adjustmentType,
    required this.exampleLabel,
  });

  final String adjustmentType;
  final String exampleLabel;
  int setCount = 0;
  int partlyOrFullyCompletedCount = 0;
  int reflectedCount = 0;
  int decreasedCount = 0;
  int unchangedCount = 0;
  int increasedCount = 0;

  WeeklyIntentionSummary build() {
    return WeeklyIntentionSummary(
      adjustmentType: adjustmentType,
      exampleLabel: exampleLabel,
      setCount: setCount,
      partlyOrFullyCompletedCount: partlyOrFullyCompletedCount,
      reflectedCount: reflectedCount,
      decreasedCount: decreasedCount,
      unchangedCount: unchangedCount,
      increasedCount: increasedCount,
    );
  }
}
