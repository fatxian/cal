import '../../../core/database/app_database.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/services/energy_model_service.dart';
import '../models/weekly_insight_aggregate.dart';
import '../models/weekly_insight_summary.dart';
import 'weekly_insight_aggregator.dart';

class WeeklyInsightService {
  const WeeklyInsightService({required this.database});

  final AppDatabase database;

  Future<DateTime> loadInsightCycleAnchor() async {
    final setup = await database
        .select(database.initialSetupItems)
        .getSingleOrNull();
    final anchor = setup?.questionnaireCompletedAt.toLocal() ?? DateTime.now();
    return DateTime(anchor.year, anchor.month, anchor.day);
  }

  Future<WeeklyInsightSummary> loadSummaryForWeek(DateTime weekStart) async {
    final aggregate = await WeeklyInsightAggregator(
      database: database,
    ).loadForWeek(weekStart);

    return WeeklyInsightSummary(
      weekStart: aggregate.weekStart,
      energyDays: aggregate.energyDays
          .map(
            (day) => WeeklyEnergyDay(
              date: day.date,
              weekday: _weekdayLabel(day.date),
              energyScore: day.energyScore,
            ),
          )
          .toList(growable: false),
      reflectionCount: aggregate.reflectionCount,
      lowEnergyCount: aggregate.lowEnergyCount,
      averageEnergy: aggregate.reflectionCount == 0
          ? null
          : aggregate.energyTotal / aggregate.reflectionCount,
      previousAverageEnergy: aggregate.previousReflectionCount == 0
          ? null
          : aggregate.previousEnergyTotal / aggregate.previousReflectionCount,
      forecastComparison: _forecastComparison(aggregate.forecastSummary),
      activityEnergySummaries: aggregate.activitySummaries
          .map(
            (summary) => WeeklyActivityEnergySummary(
              category: summary.category,
              decreasedCount: summary.decreasedCount,
              unchangedCount: summary.unchangedCount,
              increasedCount: summary.increasedCount,
            ),
          )
          .toList(growable: false),
      intentionSummaries: aggregate.intentionSummaries
          .map(_intentionInsight)
          .toList(growable: false),
      sections: [
        WeeklyInsightSection(
          title: 'Cal saw a pattern this week',
          body: _calendarPatternText(aggregate),
          subtitle: 'Based on your calendar and Daily Reflections',
          bodyParts: _calendarPatternTextParts(aggregate),
          isLocked:
              aggregate.calendarSampleCount <
              WeeklyInsightAggregator.minimumPatternSampleCount,
        ),
        WeeklyInsightSection(
          title: 'Your intentions',
          body: aggregate.intentionCount == 0
              ? 'Set an intention from Today to unlock your intention insights.'
              : '',
          isLocked: aggregate.intentionCount == 0,
        ),
        _modelSection(aggregate.modelSummary),
      ],
    );
  }

  String _calendarPatternText(WeeklyInsightAggregate aggregate) {
    final pattern = aggregate.strongestCalendarPattern;
    if (pattern == null) {
      if (aggregate.calendarSampleCount <
          WeeklyInsightAggregator.minimumPatternSampleCount) {
        return 'Keep completing forecasts and reflections to reveal your '
            'first pattern.';
      }

      return 'No clear calendar pattern stood out across your reflected days '
          'this week.';
    }

    final energyDirection =
        pattern.direction == WeeklyPatternDirection.lowerEnergy
        ? 'lower'
        : 'higher';
    final dayText = pattern.sampleCount == 1 ? 'day' : 'days';

    return 'Across the ${pattern.sampleCount} $dayText you reflected on, '
        '${_featureTrendLabel(pattern.feature)} appeared alongside '
        '$energyDirection reported energy.';
  }

  List<WeeklyInsightTextPart> _calendarPatternTextParts(
    WeeklyInsightAggregate aggregate,
  ) {
    final pattern = aggregate.strongestCalendarPattern;
    if (pattern == null) return const [];

    final energyDirection =
        pattern.direction == WeeklyPatternDirection.lowerEnergy
        ? 'lower'
        : 'higher';
    final dayText = pattern.sampleCount == 1 ? 'day' : 'days';

    return [
      const WeeklyInsightTextPart('Across the '),
      WeeklyInsightTextPart(
        '${pattern.sampleCount} $dayText you reflected on',
        isEmphasised: true,
      ),
      const WeeklyInsightTextPart(', '),
      WeeklyInsightTextPart(
        _featureTrendLabel(pattern.feature),
        isEmphasised: true,
      ),
      const WeeklyInsightTextPart(' appeared alongside '),
      WeeklyInsightTextPart(
        '$energyDirection reported energy',
        isEmphasised: true,
      ),
      const WeeklyInsightTextPart('.'),
    ];
  }

  WeeklyIntentionInsight _intentionInsight(WeeklyIntentionSummary summary) {
    return WeeklyIntentionInsight(
      adjustmentType: summary.adjustmentType,
      label: summary.exampleLabel,
      setCount: summary.setCount,
      completedCount: summary.partlyOrFullyCompletedCount,
      reflectedCount: summary.reflectedCount,
      decreasedCount: summary.decreasedCount,
      unchangedCount: summary.unchangedCount,
      increasedCount: summary.increasedCount,
    );
  }

  WeeklyForecastComparison _forecastComparison(WeeklyForecastSummary summary) {
    final sharedMatch = summary.mostFrequentSharedMatch;
    final userLower = _forecastSignal(summary.mostFrequentUserDemandingFactor);
    final modelLower = _forecastSignal(
      summary.mostFrequentModelDemandingFactor,
    );
    final userHigher = _forecastSignal(
      summary.mostFrequentUserSupportiveFactor,
    );
    final modelHigher = _forecastSignal(
      summary.mostFrequentModelSupportiveFactor,
    );
    return WeeklyForecastComparison(
      comparedDayCount: summary.agreementResponseCount,
      similarDayCount: summary.partlyOrFullyAgreedCount,
      mostFrequentSharedFactor: sharedMatch == null
          ? null
          : _factorLabel(sharedMatch.factorType),
      sharedFactorEffect: sharedMatch == null
          ? null
          : sharedMatch.direction == WeeklyForecastFactorDirection.increase
          ? WeeklyForecastFactorEffect.increase
          : WeeklyForecastFactorEffect.decrease,
      biggestDifference: _forecastDifference(summary.mostFrequentDifference),
      userLowerEnergySignal: userLower,
      modelLowerEnergySignal: modelLower,
      userHigherEnergySignal: userHigher,
      modelHigherEnergySignal: modelHigher,
    );
  }

  WeeklyForecastSignal? _forecastSignal(WeeklyFactorCount? factor) {
    if (factor == null) return null;
    return WeeklyForecastSignal(
      label: _factorLabel(factor.factorType),
      dayCount: factor.count,
    );
  }

  WeeklyForecastDifference? _forecastDifference(
    WeeklyForecastFactorDifference? difference,
  ) {
    if (difference == null) return null;

    return WeeklyForecastDifference(
      userFactor: _factorLabel(difference.userFactorType),
      userEffect:
          difference.userDirection == WeeklyForecastFactorDirection.increase
          ? WeeklyForecastFactorEffect.increase
          : WeeklyForecastFactorEffect.decrease,
      modelFactor: _factorLabel(difference.modelFactorType),
      modelEffect:
          difference.modelDirection == WeeklyForecastFactorDirection.increase
          ? WeeklyForecastFactorEffect.increase
          : WeeklyForecastFactorEffect.decrease,
    );
  }

  String _featureTrendLabel(EnergyModelFeature feature) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => 'higher total scheduled time',
      EnergyModelFeature.backToBackEventCount => 'more back-to-back activities',
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        'longer gaps between activities',
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        'a longer stretch without a break',
      EnergyModelFeature.focusMinutes => 'more time in focused activities',
      EnergyModelFeature.socialMinutes => 'more time in social activities',
      EnergyModelFeature.lifeAdminMinutes => 'more time on life admin tasks',
      EnergyModelFeature.exerciseMinutes => 'more exercise time',
    };
  }

  String _factorLabel(String factorType) {
    return switch (factorType) {
      'scheduledTime' => EnergyModelFeature.busyMinutes.displayLabel,
      'backToBackEvents' =>
        EnergyModelFeature.backToBackEventCount.displayLabel,
      'longestGapBetweenActivities' =>
        EnergyModelFeature.longestGapBetweenActivitiesMinutes.displayLabel,
      'longestScheduledBlock' =>
        EnergyModelFeature.maxConsecutiveBlockMinutes.displayLabel,
      'focusTime' => EnergyModelFeature.focusMinutes.displayLabel,
      'socialTime' => EnergyModelFeature.socialMinutes.displayLabel,
      'lifeAdminTasks' => EnergyModelFeature.lifeAdminMinutes.displayLabel,
      'exercise' => EnergyModelFeature.exerciseMinutes.displayLabel,
      _ => 'the same calendar factor',
    };
  }

  WeeklyInsightSection _modelSection(WeeklyModelSummary? summary) {
    if (summary == null) {
      return const WeeklyInsightSection(
        title: 'What Cal has learned over time',
        body:
            'Complete the initial questionnaire to give Cal a starting point.',
        subtitle: 'Based on all completed forecast and Daily Reflection days',
        isLocked: true,
      );
    }

    if (summary.modelSource != EnergyModelSource.personalisedLogistic) {
      return WeeklyInsightSection(
        title: 'What Cal has learned over time',
        body: 'Keep completing reflections to help Cal learn your patterns.',
        subtitle: 'Based on all completed forecast and Daily Reflection days',
        isLocked: true,
        modelLearningProgress: WeeklyModelLearningProgress(
          completedSampleCount: summary.completedSampleCount,
          hasLowerEnergySample: summary.hasLowerEnergySample,
          hasHigherEnergySample: summary.hasHigherEnergySample,
        ),
      );
    }

    final lowerEnergyFeature = summary.strongestLowerEnergyFeature;
    final higherEnergyFeature = summary.strongestHigherEnergyFeature;

    return WeeklyInsightSection(
      title: 'What Cal has learned over time',
      body: '',
      subtitle: 'Based on all completed forecast and Daily Reflection days',
      personalisedModelInsight: WeeklyPersonalisedModelInsight(
        lowerEnergySignal: lowerEnergyFeature == null
            ? null
            : WeeklyModelSignal(
                label: lowerEnergyFeature.displayLabel,
                description: _modelDirectionText(
                  lowerEnergyFeature,
                  lowerEnergy: true,
                ),
              ),
        higherEnergySignal: higherEnergyFeature == null
            ? null
            : WeeklyModelSignal(
                label: higherEnergyFeature.displayLabel,
                description: _modelDirectionText(
                  higherEnergyFeature,
                  lowerEnergy: false,
                ),
              ),
      ),
    );
  }

  String _modelDirectionText(
    EnergyModelFeature feature, {
    required bool lowerEnergy,
  }) {
    final direction = lowerEnergy ? 'lower energy' : 'higher energy';

    return switch (feature) {
      EnergyModelFeature.busyMinutes =>
        'More scheduled time tends to point towards $direction.',
      EnergyModelFeature.backToBackEventCount =>
        'More back-to-back activities tend to point towards $direction.',
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        'Longer gaps between activities tend to point towards $direction.',
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        'Longer stretches without a break tend to point towards $direction.',
      EnergyModelFeature.focusMinutes =>
        'More time in focused activities tends to point towards $direction.',
      EnergyModelFeature.socialMinutes =>
        'More social time tends to point towards $direction.',
      EnergyModelFeature.lifeAdminMinutes =>
        'More time on life admin tasks tends to point towards $direction.',
      EnergyModelFeature.exerciseMinutes =>
        'More exercise time tends to point towards $direction.',
    };
  }

  String _weekdayLabel(DateTime day) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[day.weekday - 1];
  }
}
