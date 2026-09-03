import '../../prediction/models/energy_model_feature.dart';

class WeeklyInsightAggregate {
  const WeeklyInsightAggregate({
    required this.weekStart,
    required this.energyDays,
    required this.reflectionCount,
    required this.lowEnergyCount,
    required this.energyTotal,
    required this.previousReflectionCount,
    required this.previousEnergyTotal,
    required this.calendarSampleCount,
    required this.strongestCalendarPattern,
    required this.activitySummaries,
    required this.forecastSummary,
    required this.intentionSummaries,
    required this.modelSummary,
    required this.intentionCount,
  });

  final DateTime weekStart;
  final List<WeeklyEnergyRecord> energyDays;
  final int reflectionCount;
  final int lowEnergyCount;
  final int energyTotal;
  final int previousReflectionCount;
  final int previousEnergyTotal;
  final int calendarSampleCount;
  final WeeklyCalendarPattern? strongestCalendarPattern;
  final List<WeeklyActivitySummary> activitySummaries;
  final WeeklyForecastSummary forecastSummary;
  final List<WeeklyIntentionSummary> intentionSummaries;
  final WeeklyModelSummary? modelSummary;
  final int intentionCount;
}

class WeeklyModelSummary {
  const WeeklyModelSummary({
    required this.modelSource,
    required this.modelVersion,
    required this.completedSampleCount,
    required this.hasLowerEnergySample,
    required this.hasHigherEnergySample,
    required this.updatedAt,
    required this.strongestLowerEnergyFeature,
    required this.strongestHigherEnergyFeature,
  });

  final String modelSource;
  final String modelVersion;
  final int completedSampleCount;
  final bool hasLowerEnergySample;
  final bool hasHigherEnergySample;
  final DateTime updatedAt;
  final EnergyModelFeature? strongestLowerEnergyFeature;
  final EnergyModelFeature? strongestHigherEnergyFeature;
}

class WeeklyForecastSummary {
  const WeeklyForecastSummary({
    required this.agreementResponseCount,
    required this.partlyOrFullyAgreedCount,
    required this.mostFrequentSharedMatch,
    required this.mostFrequentDifference,
    required this.mostFrequentUserSupportiveFactor,
    required this.mostFrequentUserDemandingFactor,
    required this.mostFrequentModelSupportiveFactor,
    required this.mostFrequentModelDemandingFactor,
  });

  final int agreementResponseCount;
  final int partlyOrFullyAgreedCount;
  final WeeklyForecastFactorMatch? mostFrequentSharedMatch;
  final WeeklyForecastFactorDifference? mostFrequentDifference;
  final WeeklyFactorCount? mostFrequentUserSupportiveFactor;
  final WeeklyFactorCount? mostFrequentUserDemandingFactor;
  final WeeklyFactorCount? mostFrequentModelSupportiveFactor;
  final WeeklyFactorCount? mostFrequentModelDemandingFactor;
}

class WeeklyForecastFactorMatch {
  const WeeklyForecastFactorMatch({
    required this.factorType,
    required this.direction,
    required this.count,
  });

  final String factorType;
  final WeeklyForecastFactorDirection direction;
  final int count;
}

enum WeeklyForecastFactorDirection { increase, decrease }

class WeeklyForecastFactorDifference {
  const WeeklyForecastFactorDifference({
    required this.userFactorType,
    required this.userDirection,
    required this.modelFactorType,
    required this.modelDirection,
    required this.count,
  });

  final String userFactorType;
  final WeeklyForecastFactorDirection userDirection;
  final String modelFactorType;
  final WeeklyForecastFactorDirection modelDirection;
  final int count;
}

class WeeklyFactorCount {
  const WeeklyFactorCount({required this.factorType, required this.count});

  final String factorType;
  final int count;
}

class WeeklyIntentionSummary {
  const WeeklyIntentionSummary({
    required this.adjustmentType,
    required this.exampleLabel,
    required this.setCount,
    required this.partlyOrFullyCompletedCount,
    required this.reflectedCount,
    required this.decreasedCount,
    required this.unchangedCount,
    required this.increasedCount,
  });

  final String adjustmentType;
  final String exampleLabel;
  final int setCount;
  final int partlyOrFullyCompletedCount;
  final int reflectedCount;
  final int decreasedCount;
  final int unchangedCount;
  final int increasedCount;
}

class WeeklyEnergyRecord {
  const WeeklyEnergyRecord({required this.date, required this.energyScore});

  final DateTime date;
  final int? energyScore;
}

class WeeklyCalendarPattern {
  const WeeklyCalendarPattern({
    required this.feature,
    required this.direction,
    required this.correlation,
    required this.sampleCount,
  });

  final EnergyModelFeature feature;
  final WeeklyPatternDirection direction;
  final double correlation;
  final int sampleCount;
}

enum WeeklyPatternDirection { lowerEnergy, higherEnergy }

class WeeklyActivitySummary {
  const WeeklyActivitySummary({
    required this.category,
    required this.decreasedCount,
    required this.unchangedCount,
    required this.increasedCount,
  });

  final String category;
  final int decreasedCount;
  final int unchangedCount;
  final int increasedCount;

  int get totalCount => decreasedCount + unchangedCount + increasedCount;
}
