import 'dart:math' as math;

import '../../../core/database/app_database.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../models/weekly_insight_aggregate.dart';

class WeeklyPatternAnalyzer {
  const WeeklyPatternAnalyzer();

  static const int minimumSampleCount = 3;
  static const double minimumCorrelation = 0.25;

  WeeklyCalendarPattern? findStrongest({
    required Map<String, DailyReflectionItem> reflectionsByDate,
    required Map<String, DailyFeatureSnapshotItem> snapshotsByDate,
  }) {
    // compare only dates containing both a feature snapshot and energy reflection
    final matchedDates = reflectionsByDate.keys
        .where(snapshotsByDate.containsKey)
        .toList();
    // require three paired days before looking for a weekly relationship
    if (matchedDates.length < minimumSampleCount) return null;

    WeeklyCalendarPattern? strongestPattern;
    for (final feature in EnergyModelContract.orderedFeatures) {
      final featureValues = matchedDates
          .map((date) => _featureValue(snapshotsByDate[date]!, feature))
          .toList();
      final energyValues = matchedDates
          .map((date) => reflectionsByDate[date]!.energyScore.toDouble())
          .toList();
      final correlation = _pearsonCorrelation(featureValues, energyValues);
      // ignore very weak correlations so they are not presented as patterns
      if (correlation == null || correlation.abs() < minimumCorrelation) {
        continue;
      }

      // use absolute strength so either energy direction can become the pattern
      if (strongestPattern == null ||
          correlation.abs() > strongestPattern.correlation.abs()) {
        strongestPattern = WeeklyCalendarPattern(
          feature: feature,
          direction: correlation < 0
              ? WeeklyPatternDirection.lowerEnergy
              : WeeklyPatternDirection.higherEnergy,
          correlation: correlation,
          sampleCount: matchedDates.length,
        );
      }
    }

    return strongestPattern;
  }

  double _featureValue(
    DailyFeatureSnapshotItem snapshot,
    EnergyModelFeature feature,
  ) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => snapshot.busyMinutes.toDouble(),
      EnergyModelFeature.backToBackEventCount =>
        snapshot.backToBackEventCount.toDouble(),
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        snapshot.longestGapBetweenActivitiesMinutes.toDouble(),
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        snapshot.maxConsecutiveBlockMinutes.toDouble(),
      EnergyModelFeature.focusMinutes => snapshot.focusMinutes.toDouble(),
      EnergyModelFeature.socialMinutes => snapshot.socialMinutes.toDouble(),
      EnergyModelFeature.lifeAdminMinutes =>
        snapshot.lifeAdminMinutes.toDouble(),
      EnergyModelFeature.exerciseMinutes => snapshot.exerciseMinutes.toDouble(),
    };
  }

  double? _pearsonCorrelation(List<double> first, List<double> second) {
    final firstMean = first.reduce((a, b) => a + b) / first.length;
    final secondMean = second.reduce((a, b) => a + b) / second.length;
    var covariance = 0.0;
    var firstVariance = 0.0;
    var secondVariance = 0.0;

    for (var index = 0; index < first.length; index++) {
      final firstDelta = first[index] - firstMean;
      final secondDelta = second[index] - secondMean;
      covariance += firstDelta * secondDelta;
      firstVariance += firstDelta * firstDelta;
      secondVariance += secondDelta * secondDelta;
    }

    final denominator = math.sqrt(firstVariance * secondVariance);
    if (denominator == 0) return null;
    return covariance / denominator;
  }
}
