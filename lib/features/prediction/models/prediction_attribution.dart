import 'energy_model_feature.dart';

class PredictionAttribution {
  const PredictionAttribution({
    required this.feature,
    required this.contribution,
    required this.sentence,
  });

  final EnergyModelFeature feature;
  final double contribution;
  final String sentence;

  bool get raisesLowEnergy => contribution > 0;
}
