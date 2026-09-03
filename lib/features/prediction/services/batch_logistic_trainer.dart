import 'dart:math' as math;

import '../models/energy_model_feature.dart';
import '../models/logistic_model_parameters.dart';
import '../models/training_sample.dart';
import 'energy_feature_scaler.dart';

class BatchLogisticTrainer {
  const BatchLogisticTrainer({
    this.scaler = const EnergyFeatureScaler(),
    this.minimumSampleCount = 7,
    // fixed iterations keep on-device training simple and predictable
    this.iterations = 800,
    // initial step size for the decaying gradient descent updates
    this.learningRate = 0.5,
    // small L2 penalty to keep early personalised models stable with limited data
    this.l2Penalty = 0.02,
    this.modelVersion = 'personalised-logistic-v2',
  });

  final EnergyFeatureScaler scaler;
  final int minimumSampleCount;
  final int iterations;
  final double learningRate;
  final double l2Penalty;
  final String modelVersion;

  LogisticModelParameters train(List<TrainingSample> samples) {
    // check there are enough samples and both outcome classes
    _checkSamples(samples);

    // scale the features and prepare the labels
    final rows = samples
        .map((sample) => scaler.scale(sample.features).orderedValues)
        .toList(growable: false);
    final labels = samples
        .map((sample) => sample.lowEnergyLabel.toDouble())
        .toList(growable: false);
    var intercept = 0.0;
    final coefficients = List<double>.filled(
      EnergyModelContract.orderedFeatures.length,
      0,
    );

    // repeatedly update the model parameters during training
    for (var iteration = 0; iteration < iterations; iteration++) {
      var interceptGradient = 0.0;
      final coefficientGradients = List<double>.filled(coefficients.length, 0);

      for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        final row = rows[rowIndex];
        final prediction = _sigmoid(intercept + _dot(row, coefficients));
        final error = prediction - labels[rowIndex];

        interceptGradient += error;
        for (var featureIndex = 0; featureIndex < row.length; featureIndex++) {
          coefficientGradients[featureIndex] += error * row[featureIndex];
        }
      }

      final sampleCount = samples.length;
      // reduce the learning rate during training
      final stepSize = learningRate / math.sqrt(iteration + 1);
      intercept = _clampParameter(
        intercept - stepSize * (interceptGradient / sampleCount),
      );

      for (var index = 0; index < coefficients.length; index++) {
        // apply L2 regularisation to the coefficients
        final gradient =
            (coefficientGradients[index] / sampleCount) +
            (l2Penalty * coefficients[index]);
        coefficients[index] = _clampParameter(
          coefficients[index] - stepSize * gradient,
        );
      }
    }

    return LogisticModelParameters(
      featureVersion: EnergyModelContract.featureVersion,
      targetVersion: EnergyModelContract.targetVersion,
      modelVersion: modelVersion,
      intercept: intercept,
      coefficients: {
        for (
          var index = 0;
          index < EnergyModelContract.orderedFeatures.length;
          index++
        )
          EnergyModelContract.orderedFeatures[index]: coefficients[index],
      },
    );
  }

  void _checkSamples(List<TrainingSample> samples) {
    if (samples.length < minimumSampleCount) {
      throw StateError(
        'At least $minimumSampleCount completed samples are required.',
      );
    }

    final labels = samples.map((sample) => sample.lowEnergyLabel).toSet();
    if (!labels.contains(0) || !labels.contains(1)) {
      throw StateError('Both low and not-low energy samples are required.');
    }

    if (labels.any((label) => label != 0 && label != 1)) {
      throw StateError('Training labels must be binary.');
    }
  }

  double _dot(List<double> values, List<double> coefficients) {
    var total = 0.0;

    for (var index = 0; index < values.length; index++) {
      total += values[index] * coefficients[index];
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

  // keep parameters bounded so small on-device datasets don't produce extreme probabilities
  double _clampParameter(double value) {
    return value.clamp(-8.0, 8.0);
  }
}
