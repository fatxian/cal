import '../models/daily_calendar_features.dart';
import '../models/energy_model_feature.dart';
import '../models/logistic_model_parameters.dart';
import '../models/prediction_attribution.dart';
import 'energy_feature_scaler.dart';

class PredictionAttributionService {
  const PredictionAttributionService({
    this.scaler = const EnergyFeatureScaler(),
  });

  final EnergyFeatureScaler scaler;

  List<PredictionAttribution> topAttributions({
    required DailyCalendarFeatures features,
    required LogisticModelParameters parameters,
    int limit = 3,
  }) {
    // scale the features in the same order as the model coefficients
    final scaledValues = scaler.scale(features).orderedValues;
    // calculate each feature's contribution and rank the strongest first
    final contributions =
        [
          for (
            var index = 0;
            index < EnergyModelContract.orderedFeatures.length;
            index++
          )
            PredictionAttribution(
              feature: EnergyModelContract.orderedFeatures[index],
              contribution:
                  scaledValues[index] * parameters.orderedCoefficients[index],
              sentence: _sentenceForContribution(
                EnergyModelContract.orderedFeatures[index],
                scaledValues[index] * parameters.orderedCoefficients[index],
                features,
              ),
            ),
        ]..sort(
          (first, second) =>
              second.contribution.abs().compareTo(first.contribution.abs()),
        );

    // ignore features with no value or no contribution
    return contributions
        .where(
          (contribution) =>
              _rawValueForFeature(features, contribution.feature) != 0 &&
              contribution.contribution != 0,
        )
        .take(limit)
        .toList(growable: false);
  }

  num _rawValueForFeature(
    DailyCalendarFeatures features,
    EnergyModelFeature feature,
  ) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => features.busyMinutes,
      EnergyModelFeature.backToBackEventCount => features.backToBackEventCount,
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        features.longestGapBetweenActivitiesMinutes,
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        features.maxConsecutiveBlockMinutes,
      EnergyModelFeature.focusMinutes => features.focusMinutes,
      EnergyModelFeature.socialMinutes => features.socialMinutes,
      EnergyModelFeature.lifeAdminMinutes => features.lifeAdminMinutes,
      EnergyModelFeature.exerciseMinutes => features.exerciseMinutes,
    };
  }

  String _sentenceForContribution(
    EnergyModelFeature feature,
    double contribution,
    DailyCalendarFeatures features,
  ) {
    // use the contribution sign to decide the energy direction
    final raisesLowEnergy = contribution > 0;
    final direction = raisesLowEnergy
        ? 'towards lower energy'
        : 'towards higher energy';
    final context = switch (feature) {
      EnergyModelFeature.busyMinutes =>
        'Your schedule includes around ${_durationText(features.busyMinutes)} '
            'of planned activities today.',
      EnergyModelFeature.backToBackEventCount =>
        'Your schedule has ${_countText(features.backToBackEventCount, 'back-to-back transition')} today.',
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        'Your schedule includes a gap of around '
            '${_durationText(features.longestGapBetweenActivitiesMinutes)} '
            'between activities today.',
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        'Your longest stretch without a break is around '
            '${_durationText(features.maxConsecutiveBlockMinutes)} today.',
      EnergyModelFeature.focusMinutes =>
        'Your schedule includes around ${_durationText(features.focusMinutes)} '
            'of focused activities today.',
      EnergyModelFeature.socialMinutes =>
        'Your schedule includes around ${_durationText(features.socialMinutes)} '
            'of social activities today.',
      EnergyModelFeature.lifeAdminMinutes =>
        'Your schedule includes around '
            '${_durationText(features.lifeAdminMinutes)} of life admin tasks today.',
      EnergyModelFeature.exerciseMinutes =>
        'Your schedule includes around '
            '${_durationText(features.exerciseMinutes)} of exercise today.',
    };

    return '$context Cal saw this as one of the strongest signals pointing '
        '$direction.';
  }

  String _durationText(int minutes) {
    if (minutes < 60) return '$minutes minutes';
    if (minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }

    final hours = minutes / 60;
    return '${hours.toStringAsFixed(1)} hours';
  }

  String _countText(int count, String singular) {
    return '$count ${count == 1 ? singular : '${singular}s'}';
  }
}
