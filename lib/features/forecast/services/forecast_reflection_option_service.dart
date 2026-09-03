import '../../calendar/models/calendar_event.dart';
import '../../prediction/models/daily_calendar_features.dart';
import '../../prediction/models/logistic_model_parameters.dart';
import '../../prediction/models/prediction_attribution.dart';
import '../../prediction/services/daily_feature_calculator.dart';
import '../../prediction/services/prediction_attribution_service.dart';
import '../models/daily_intention.dart';
import '../models/forecast_model_view.dart';
import '../models/forecast_reflection_option.dart';
import 'forecast_adjustment_catalog.dart';
import 'forecast_comparison_service.dart';
import 'forecast_factor_mapper.dart';
import 'forecast_factor_option_service.dart';
import 'forecast_intention_suggestion_service.dart';
import 'forecast_model_view_service.dart';
import 'future_availability_service.dart';

/// keeps the existing Forecast API while delegating each rule set to its
/// focused service
class ForecastReflectionOptionService {
  const ForecastReflectionOptionService({
    this.featureCalculator = const DailyFeatureCalculator(),
    this.attributionService = const PredictionAttributionService(),
    this.futureAvailabilityService = const FutureAvailabilityService(),
  });

  final DailyFeatureCalculator featureCalculator;
  final PredictionAttributionService attributionService;
  final FutureAvailabilityService futureAvailabilityService;

  List<ForecastFactorOption> buildForecastFactorOptions({
    required DateTime day,
    required List<CalendarEvent> events,
  }) {
    return ForecastFactorOptionService(
      featureCalculator: featureCalculator,
    ).build(day: day, events: events);
  }

  ForecastModelView buildModelView({
    required DailyCalendarFeatures features,
    required LogisticModelParameters? modelParameters,
  }) {
    return ForecastModelViewService(
      attributionService: attributionService,
    ).build(features: features, modelParameters: modelParameters);
  }

  List<ForecastIntentionOption> buildIntentionOptions({
    required DateTime day,
    required List<CalendarEvent> events,
    required ForecastFactorOption supportiveFactor,
    required ForecastFactorOption demandingFactor,
    required ForecastModelView modelView,
    DateTime? now,
  }) {
    return ForecastIntentionSuggestionService(
      featureCalculator: featureCalculator,
      futureAvailabilityService: futureAvailabilityService,
      adjustmentCatalog: ForecastAdjustmentCatalog(
        futureAvailabilityService: futureAvailabilityService,
      ),
    ).build(
      day: day,
      events: events,
      supportiveFactor: supportiveFactor,
      demandingFactor: demandingFactor,
      modelView: modelView,
      now: now,
    );
  }

  String comparisonMessage({
    required ForecastFactorType supportiveFactor,
    required ForecastFactorType demandingFactor,
    required ForecastModelView modelView,
  }) {
    return const ForecastComparisonService().message(
      supportiveFactor: supportiveFactor,
      demandingFactor: demandingFactor,
      modelView: modelView,
    );
  }

  String comparisonMessageForSavedFactors({
    required ForecastFactorType supportiveFactor,
    required ForecastFactorType demandingFactor,
    ForecastFactorType? modelSupportiveFactor,
    ForecastFactorType? modelDemandingFactor,
  }) {
    return const ForecastComparisonService().messageForSavedFactors(
      supportiveFactor: supportiveFactor,
      demandingFactor: demandingFactor,
      modelSupportiveFactor: modelSupportiveFactor,
      modelDemandingFactor: modelDemandingFactor,
    );
  }

  ForecastFactor factorForAttribution(PredictionAttribution attribution) {
    return const ForecastFactorMapper().factorForAttribution(attribution);
  }
}
