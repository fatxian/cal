import 'daily_intention.dart';

class ForecastReflection {
  const ForecastReflection({
    required this.predictionId,
    required this.supportiveFactor,
    required this.demandingFactor,
    required this.revealedAt,
    this.modelSupportiveFactor,
    this.modelDemandingFactor,
  });

  final int predictionId;
  final ForecastFactor supportiveFactor;
  final ForecastFactor demandingFactor;
  final ForecastFactor? modelSupportiveFactor;
  final ForecastFactor? modelDemandingFactor;
  final DateTime revealedAt;
}
