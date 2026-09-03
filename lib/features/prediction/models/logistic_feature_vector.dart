import 'energy_model_feature.dart';

class LogisticFeatureVector {
  const LogisticFeatureVector({
    required this.busyMinutes,
    required this.backToBackEventCount,
    required this.longestGapBetweenActivitiesMinutes,
    required this.maxConsecutiveBlockMinutes,
    required this.focusMinutes,
    required this.socialMinutes,
    required this.lifeAdminMinutes,
    required this.exerciseMinutes,
  });

  final double busyMinutes;
  final double backToBackEventCount;
  final double longestGapBetweenActivitiesMinutes;
  final double maxConsecutiveBlockMinutes;
  final double focusMinutes;
  final double socialMinutes;
  final double lifeAdminMinutes;
  final double exerciseMinutes;

  String get featureVersion => EnergyModelContract.featureVersion;

  double valueFor(EnergyModelFeature feature) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => busyMinutes,
      EnergyModelFeature.backToBackEventCount => backToBackEventCount,
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        longestGapBetweenActivitiesMinutes,
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        maxConsecutiveBlockMinutes,
      EnergyModelFeature.focusMinutes => focusMinutes,
      EnergyModelFeature.socialMinutes => socialMinutes,
      EnergyModelFeature.lifeAdminMinutes => lifeAdminMinutes,
      EnergyModelFeature.exerciseMinutes => exerciseMinutes,
    };
  }

  List<double> get orderedValues =>
      EnergyModelContract.orderedFeatures.map(valueFor).toList(growable: false);
}
