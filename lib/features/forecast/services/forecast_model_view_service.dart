import '../../prediction/models/daily_calendar_features.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/models/logistic_model_parameters.dart';
import '../../prediction/services/prediction_attribution_service.dart';
import '../models/forecast_model_view.dart';

class ForecastModelViewService {
  const ForecastModelViewService({
    this.attributionService = const PredictionAttributionService(),
  });

  final PredictionAttributionService attributionService;

  ForecastModelView build({
    required DailyCalendarFeatures features,
    required LogisticModelParameters? modelParameters,
  }) {
    if (modelParameters == null) return const ForecastModelView.empty();

    final attributions = attributionService.topAttributions(
      features: features,
      parameters: modelParameters,
      limit: EnergyModelContract.orderedFeatures.length,
    );
    final supportiveFeatures =
        EnergyModelContract.orderedFeatures
            .where((feature) => modelParameters.coefficientFor(feature) < 0)
            .toList()
          ..sort(
            (first, second) => modelParameters
                .coefficientFor(first)
                .compareTo(modelParameters.coefficientFor(second)),
          );

    return ForecastModelView(
      supportiveSignals: attributions
          .where((attribution) => !attribution.raisesLowEnergy)
          .take(1)
          .toList(growable: false),
      demandingSignals: attributions
          .where((attribution) => attribution.raisesLowEnergy)
          .take(1)
          .toList(growable: false),
      supportiveFeatures: supportiveFeatures,
    );
  }
}
