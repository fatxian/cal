import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/models/prediction_attribution.dart';
import '../models/daily_intention.dart';

class ForecastFactorMapper {
  const ForecastFactorMapper();

  ForecastFactor factorForAttribution(PredictionAttribution attribution) {
    return ForecastFactor(
      type: typeForFeature(attribution.feature),
      label: attribution.feature.displayLabel,
    );
  }

  EnergyModelFeature? featureForType(ForecastFactorType type) {
    return switch (type) {
      ForecastFactorType.scheduledTime => EnergyModelFeature.busyMinutes,
      ForecastFactorType.backToBackEvents =>
        EnergyModelFeature.backToBackEventCount,
      ForecastFactorType.longestGapBetweenActivities =>
        EnergyModelFeature.longestGapBetweenActivitiesMinutes,
      ForecastFactorType.longestScheduledBlock =>
        EnergyModelFeature.maxConsecutiveBlockMinutes,
      ForecastFactorType.focusTime => EnergyModelFeature.focusMinutes,
      ForecastFactorType.socialTime => EnergyModelFeature.socialMinutes,
      ForecastFactorType.lifeAdminTasks => EnergyModelFeature.lifeAdminMinutes,
      ForecastFactorType.exercise => EnergyModelFeature.exerciseMinutes,
      _ => null,
    };
  }

  ForecastFactorType typeForFeature(EnergyModelFeature feature) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => ForecastFactorType.scheduledTime,
      EnergyModelFeature.backToBackEventCount =>
        ForecastFactorType.backToBackEvents,
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        ForecastFactorType.longestGapBetweenActivities,
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        ForecastFactorType.longestScheduledBlock,
      EnergyModelFeature.focusMinutes => ForecastFactorType.focusTime,
      EnergyModelFeature.socialMinutes => ForecastFactorType.socialTime,
      EnergyModelFeature.lifeAdminMinutes => ForecastFactorType.lifeAdminTasks,
      EnergyModelFeature.exerciseMinutes => ForecastFactorType.exercise,
    };
  }
}
