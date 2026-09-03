import 'daily_intention.dart';

import '../../prediction/models/energy_model_feature.dart';

class ForecastFactorOption {
  const ForecastFactorOption({
    required this.type,
    required this.label,
    this.feature,
  });

  final ForecastFactorType type;
  final String label;
  final EnergyModelFeature? feature;

  ForecastFactor toFactor() {
    return ForecastFactor(type: type, label: label);
  }
}

class ForecastIntentionOption {
  const ForecastIntentionOption({
    required this.sourceLabel,
    required this.factor,
    required this.adjustment,
    this.isRefreshable = false,
  });

  final String sourceLabel;
  final ForecastFactor factor;
  final DailyAdjustment adjustment;
  final bool isRefreshable;
}
