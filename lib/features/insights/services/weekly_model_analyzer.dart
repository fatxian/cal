import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/models/logistic_model_parameters.dart';
import '../models/weekly_insight_aggregate.dart';

class WeeklyModelAnalyzer {
  const WeeklyModelAnalyzer();

  WeeklyModelSummary build({
    required LogisticModelParameters parameters,
    required String modelSource,
    required DateTime updatedAt,
    required int completedSampleCount,
    required bool hasLowerEnergySample,
    required bool hasHigherEnergySample,
  }) {
    EnergyModelFeature? strongestLowerEnergyFeature;
    EnergyModelFeature? strongestHigherEnergyFeature;

    for (final feature in EnergyModelContract.orderedFeatures) {
      final coefficient = parameters.coefficientFor(feature);
      if (coefficient > 0 &&
          (strongestLowerEnergyFeature == null ||
              coefficient >
                  parameters.coefficientFor(strongestLowerEnergyFeature))) {
        strongestLowerEnergyFeature = feature;
      }
      if (coefficient < 0 &&
          (strongestHigherEnergyFeature == null ||
              coefficient <
                  parameters.coefficientFor(strongestHigherEnergyFeature))) {
        strongestHigherEnergyFeature = feature;
      }
    }

    return WeeklyModelSummary(
      modelSource: modelSource,
      modelVersion: parameters.modelVersion,
      completedSampleCount: completedSampleCount,
      hasLowerEnergySample: hasLowerEnergySample,
      hasHigherEnergySample: hasHigherEnergySample,
      updatedAt: updatedAt,
      strongestLowerEnergyFeature: strongestLowerEnergyFeature,
      strongestHigherEnergyFeature: strongestHigherEnergyFeature,
    );
  }
}
