import '../../../core/database/app_database.dart';
import '../models/weekly_insight_aggregate.dart';
import 'weekly_activity_aggregator.dart';
import 'weekly_energy_intention_analyzer.dart';
import 'weekly_forecast_analyzer.dart';
import 'weekly_insight_repository.dart';
import 'weekly_model_analyzer.dart';
import 'weekly_pattern_analyzer.dart';

class WeeklyInsightAggregator {
  const WeeklyInsightAggregator({required this.database});

  static const int minimumPatternSampleCount =
      WeeklyPatternAnalyzer.minimumSampleCount;
  static const double minimumPatternCorrelation =
      WeeklyPatternAnalyzer.minimumCorrelation;

  final AppDatabase database;

  Future<WeeklyInsightAggregate> loadForWeek(DateTime weekStart) async {
    final data = await WeeklyInsightRepository(
      database: database,
    ).load(weekStart);
    final energyAndIntentions = const WeeklyEnergyIntentionAnalyzer().build(
      weekStart: data.weekStart,
      reflections: data.reflections,
      previousReflections: data.previousReflections,
      intentions: data.intentions,
    );
    final reflectionsByDate = {
      for (final reflection in data.reflections) reflection.date: reflection,
    };
    final snapshotsByDate = {
      for (final snapshot in data.snapshots) snapshot.date: snapshot,
    };
    final calendarSampleCount = reflectionsByDate.keys
        .where(snapshotsByDate.containsKey)
        .length;
    final activeModel = data.activeModel;
    final activeModelMetadata = data.activeModelMetadata;

    return WeeklyInsightAggregate(
      weekStart: data.weekStart,
      energyDays: energyAndIntentions.energyDays,
      reflectionCount: energyAndIntentions.reflectionCount,
      lowEnergyCount: energyAndIntentions.lowEnergyCount,
      energyTotal: energyAndIntentions.energyTotal,
      previousReflectionCount: energyAndIntentions.previousReflectionCount,
      previousEnergyTotal: energyAndIntentions.previousEnergyTotal,
      calendarSampleCount: calendarSampleCount,
      strongestCalendarPattern: const WeeklyPatternAnalyzer().findStrongest(
        reflectionsByDate: reflectionsByDate,
        snapshotsByDate: snapshotsByDate,
      ),
      activitySummaries: const WeeklyActivityAggregator().build(
        eventResponses: data.eventResponses,
        manualEventResponses: data.manualEventResponses,
      ),
      forecastSummary: const WeeklyForecastAnalyzer().build(
        reflections: data.forecastReflections,
        predictions: data.predictions,
      ),
      intentionSummaries: energyAndIntentions.intentionSummaries,
      modelSummary: activeModel == null || activeModelMetadata == null
          ? null
          : const WeeklyModelAnalyzer().build(
              parameters: activeModel,
              modelSource: activeModelMetadata.modelSource,
              updatedAt: activeModelMetadata.createdAt,
              completedSampleCount: data.completedSamples.length,
              hasLowerEnergySample: data.completedSamples.any(
                (sample) => sample.lowEnergyLabel == 1,
              ),
              hasHigherEnergySample: data.completedSamples.any(
                (sample) => sample.lowEnergyLabel == 0,
              ),
            ),
      intentionCount: energyAndIntentions.intentionCount,
    );
  }
}
