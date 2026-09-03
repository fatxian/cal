import 'energy_model_feature.dart';

class LogisticModelParameters {
  const LogisticModelParameters({
    required this.featureVersion,
    required this.targetVersion,
    required this.modelVersion,
    required this.intercept,
    required this.coefficients,
  });

  final String featureVersion;
  final String targetVersion;
  final String modelVersion;
  final double intercept;
  final Map<EnergyModelFeature, double> coefficients;

  double coefficientFor(EnergyModelFeature feature) {
    return coefficients[feature] ?? 0;
  }

  List<double> get orderedCoefficients => EnergyModelContract.orderedFeatures
      .map(coefficientFor)
      .toList(growable: false);
}
