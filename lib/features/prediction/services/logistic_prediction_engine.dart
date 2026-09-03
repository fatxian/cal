import 'dart:math' as math;

import '../models/daily_calendar_features.dart';
import '../models/daily_prediction.dart';
import '../models/energy_model_feature.dart';
import '../models/logistic_model_parameters.dart';
import 'daily_prediction_engine.dart';
import 'energy_feature_scaler.dart';
import 'prediction_attribution_service.dart';

class LogisticPredictionEngine extends DailyPredictionEngine {
  const LogisticPredictionEngine({
    required this.parameters,
    this.scaler = const EnergyFeatureScaler(),
    this.attributionService = const PredictionAttributionService(),
    this.lowEnergyThreshold = 0.5,
  });

  final LogisticModelParameters parameters;
  final EnergyFeatureScaler scaler;
  final PredictionAttributionService attributionService;
  final double lowEnergyThreshold;

  @override
  DailyPredictionResult predict(DailyCalendarFeatures features) {
    _checkModelCompatibility();

    final vector = scaler.scale(features);
    final z = parameters.intercept + _weightedFeatureSum(vector.orderedValues);
    final probability = _sigmoid(z);
    final category = probability >= lowEnergyThreshold
        ? DailyPredictionCategory.low
        : DailyPredictionCategory.sufficient;

    return DailyPredictionResult(
      predictedCategory: category,
      predictedScore: probability,
      reasons: _reasonLabels(features),
      predictionVersion: parameters.modelVersion,
    );
  }

  double _weightedFeatureSum(List<double> orderedFeatureValues) {
    final coefficients = parameters.orderedCoefficients;
    var total = 0.0;

    for (var index = 0; index < orderedFeatureValues.length; index++) {
      total += orderedFeatureValues[index] * coefficients[index];
    }

    return total;
  }

  double _sigmoid(double z) {
    if (z >= 0) {
      final exponent = math.exp(-z);
      return 1 / (1 + exponent);
    }

    final exponent = math.exp(z);
    return exponent / (1 + exponent);
  }

  List<String> _reasonLabels(DailyCalendarFeatures features) {
    final activeFeatures = attributionService
        .topAttributions(features: features, parameters: parameters)
        .map((attribution) => attribution.sentence)
        .toList(growable: false);

    if (activeFeatures.isEmpty) {
      return ['Your schedule has limited signals for today\'s forecast.'];
    }

    return activeFeatures;
  }

  void _checkModelCompatibility() {
    if (parameters.featureVersion != EnergyModelContract.featureVersion) {
      throw StateError(
        'Model feature version ${parameters.featureVersion} is not compatible '
        'with ${EnergyModelContract.featureVersion}.',
      );
    }

    if (parameters.targetVersion != EnergyModelContract.targetVersion) {
      throw StateError(
        'Model target version ${parameters.targetVersion} is not compatible '
        'with ${EnergyModelContract.targetVersion}.',
      );
    }
  }
}
