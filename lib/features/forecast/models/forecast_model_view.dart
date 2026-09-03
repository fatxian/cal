import '../../prediction/models/prediction_attribution.dart';
import '../../prediction/models/energy_model_feature.dart';

class ForecastModelView {
  const ForecastModelView({
    required this.supportiveSignals,
    required this.demandingSignals,
    this.supportiveFeatures = const [],
  });

  const ForecastModelView.empty()
    : supportiveSignals = const [],
      demandingSignals = const [],
      supportiveFeatures = const [];

  final List<PredictionAttribution> supportiveSignals;
  final List<PredictionAttribution> demandingSignals;
  final List<EnergyModelFeature> supportiveFeatures;
}
