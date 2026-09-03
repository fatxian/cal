class DailyReflection {
  const DailyReflection({
    required this.energyScore,
    this.intentionCompletionScore,
    this.intentionHelpfulnessScore,
  });

  final int energyScore;
  final int? intentionCompletionScore;
  final int? intentionHelpfulnessScore;
}
