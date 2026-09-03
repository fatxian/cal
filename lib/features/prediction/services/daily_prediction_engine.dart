import '../models/daily_calendar_features.dart';

abstract class DailyPredictionEngine {
  const DailyPredictionEngine();

  DailyPredictionResult predict(DailyCalendarFeatures features);
}

class DailyPredictionResult {
  const DailyPredictionResult({
    required this.predictedCategory,
    required this.predictedScore,
    required this.reasons,
    required this.predictionVersion,
  });

  final String predictedCategory;
  final double? predictedScore;
  final List<String> reasons;
  final String predictionVersion;
}
