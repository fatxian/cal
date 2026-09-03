abstract final class DailyPredictionCategory {
  static const String low = 'low';
  static const String sufficient = 'sufficient';
}

abstract final class DailyPredictionAgreement {
  static const int notReally = 0;
  static const int partly = 1;
  static const int yes = 2;

  static bool isValid(int score) {
    return score >= notReally && score <= yes;
  }
}

class DailyPrediction {
  const DailyPrediction({
    required this.id,
    required this.day,
    required this.featureSnapshotId,
    required this.predictedCategory,
    required this.predictedScore,
    required this.reasons,
    required this.predictionVersion,
    required this.createdAt,
    this.agreementScore,
    this.feedbackUpdatedAt,
  });

  final int id;
  final DateTime day;
  final int featureSnapshotId;
  final String predictedCategory;
  final double? predictedScore;
  final List<String> reasons;
  final String predictionVersion;
  final DateTime createdAt;
  final int? agreementScore;
  final DateTime? feedbackUpdatedAt;
}
