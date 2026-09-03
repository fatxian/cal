import 'daily_calendar_features.dart';

class TrainingSample {
  const TrainingSample({
    required this.day,
    required this.featureSnapshotId,
    required this.predictionId,
    required this.features,
    required this.energyScore,
    required this.lowEnergyLabel,
    required this.predictionVersion,
    this.predictedScore,
    this.predictionAgreementScore,
    this.intentionCompletionScore,
    this.intentionHelpfulnessScore,
  });

  final DateTime day;
  final int featureSnapshotId;
  final int predictionId;
  final DailyCalendarFeatures features;
  final int energyScore;
  final int lowEnergyLabel;
  final String predictionVersion;
  final double? predictedScore;
  final int? predictionAgreementScore;
  final int? intentionCompletionScore;
  final int? intentionHelpfulnessScore;
}
