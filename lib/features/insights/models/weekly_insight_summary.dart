class WeeklyInsightSummary {
  const WeeklyInsightSummary({
    required this.weekStart,
    required this.energyDays,
    required this.reflectionCount,
    required this.lowEnergyCount,
    required this.averageEnergy,
    required this.previousAverageEnergy,
    required this.forecastComparison,
    required this.activityEnergySummaries,
    required this.intentionSummaries,
    required this.sections,
  });

  final DateTime weekStart;
  final List<WeeklyEnergyDay> energyDays;
  final int reflectionCount;
  final int lowEnergyCount;
  final double? averageEnergy;
  final double? previousAverageEnergy;
  final WeeklyForecastComparison forecastComparison;
  final List<WeeklyActivityEnergySummary> activityEnergySummaries;
  final List<WeeklyIntentionInsight> intentionSummaries;
  final List<WeeklyInsightSection> sections;
}

class WeeklyIntentionInsight {
  const WeeklyIntentionInsight({
    required this.adjustmentType,
    required this.label,
    required this.setCount,
    required this.completedCount,
    required this.reflectedCount,
    required this.decreasedCount,
    required this.unchangedCount,
    required this.increasedCount,
  });

  final String adjustmentType;
  final String label;
  final int setCount;
  final int completedCount;
  final int reflectedCount;
  final int decreasedCount;
  final int unchangedCount;
  final int increasedCount;
}

class WeeklyForecastComparison {
  const WeeklyForecastComparison({
    required this.comparedDayCount,
    required this.similarDayCount,
    required this.mostFrequentSharedFactor,
    required this.sharedFactorEffect,
    required this.biggestDifference,
    required this.userLowerEnergySignal,
    required this.modelLowerEnergySignal,
    required this.userHigherEnergySignal,
    required this.modelHigherEnergySignal,
  });

  final int comparedDayCount;
  final int similarDayCount;
  final String? mostFrequentSharedFactor;
  final WeeklyForecastFactorEffect? sharedFactorEffect;
  final WeeklyForecastDifference? biggestDifference;
  final WeeklyForecastSignal? userLowerEnergySignal;
  final WeeklyForecastSignal? modelLowerEnergySignal;
  final WeeklyForecastSignal? userHigherEnergySignal;
  final WeeklyForecastSignal? modelHigherEnergySignal;
}

class WeeklyForecastSignal {
  const WeeklyForecastSignal({required this.label, required this.dayCount});

  final String label;
  final int dayCount;
}

enum WeeklyForecastFactorEffect { increase, decrease }

class WeeklyForecastDifference {
  const WeeklyForecastDifference({
    required this.userFactor,
    required this.userEffect,
    required this.modelFactor,
    required this.modelEffect,
  });

  final String userFactor;
  final WeeklyForecastFactorEffect userEffect;
  final String modelFactor;
  final WeeklyForecastFactorEffect modelEffect;
}

class WeeklyActivityEnergySummary {
  const WeeklyActivityEnergySummary({
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

class WeeklyEnergyDay {
  const WeeklyEnergyDay({
    required this.date,
    required this.weekday,
    required this.energyScore,
  });

  final DateTime date;
  final String weekday;
  final int? energyScore;
}

class WeeklyInsightSection {
  const WeeklyInsightSection({
    required this.title,
    required this.body,
    this.isLocked = false,
    this.subtitle,
    this.bodyParts = const [],
    this.modelLearningProgress,
    this.personalisedModelInsight,
  });

  final String title;
  final String body;
  final bool isLocked;
  final String? subtitle;
  final List<WeeklyInsightTextPart> bodyParts;
  final WeeklyModelLearningProgress? modelLearningProgress;
  final WeeklyPersonalisedModelInsight? personalisedModelInsight;
}

class WeeklyInsightTextPart {
  const WeeklyInsightTextPart(this.text, {this.isEmphasised = false});

  final String text;
  final bool isEmphasised;
}

class WeeklyPersonalisedModelInsight {
  const WeeklyPersonalisedModelInsight({
    required this.lowerEnergySignal,
    required this.higherEnergySignal,
  });

  final WeeklyModelSignal? lowerEnergySignal;
  final WeeklyModelSignal? higherEnergySignal;
}

class WeeklyModelSignal {
  const WeeklyModelSignal({required this.label, required this.description});

  final String label;
  final String description;
}

class WeeklyModelLearningProgress {
  const WeeklyModelLearningProgress({
    required this.completedSampleCount,
    required this.hasLowerEnergySample,
    required this.hasHigherEnergySample,
  });

  final int completedSampleCount;
  final bool hasLowerEnergySample;
  final bool hasHigherEnergySample;
}
