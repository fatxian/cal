import '../models/daily_intention.dart';
import '../models/forecast_model_view.dart';
import 'forecast_factor_mapper.dart';

class ForecastComparisonService {
  const ForecastComparisonService({
    this.factorMapper = const ForecastFactorMapper(),
  });

  final ForecastFactorMapper factorMapper;

  String message({
    required ForecastFactorType supportiveFactor,
    required ForecastFactorType demandingFactor,
    required ForecastModelView modelView,
  }) {
    final supportiveModelTypes = modelView.supportiveSignals
        .map((signal) => factorMapper.typeForFeature(signal.feature))
        .toSet();
    final demandingModelTypes = modelView.demandingSignals
        .map((signal) => factorMapper.typeForFeature(signal.feature))
        .toSet();

    return _messageForTypes(
      supportiveFactor: supportiveFactor,
      demandingFactor: demandingFactor,
      supportiveModelTypes: supportiveModelTypes,
      demandingModelTypes: demandingModelTypes,
    );
  }

  String messageForSavedFactors({
    required ForecastFactorType supportiveFactor,
    required ForecastFactorType demandingFactor,
    ForecastFactorType? modelSupportiveFactor,
    ForecastFactorType? modelDemandingFactor,
  }) {
    return _messageForTypes(
      supportiveFactor: supportiveFactor,
      demandingFactor: demandingFactor,
      supportiveModelTypes: {
        if (modelSupportiveFactor != null) modelSupportiveFactor,
      },
      demandingModelTypes: {
        if (modelDemandingFactor != null) modelDemandingFactor,
      },
    );
  }

  String _messageForTypes({
    required ForecastFactorType supportiveFactor,
    required ForecastFactorType demandingFactor,
    required Set<ForecastFactorType> supportiveModelTypes,
    required Set<ForecastFactorType> demandingModelTypes,
  }) {
    final supportiveMatches = supportiveModelTypes.contains(supportiveFactor);
    final demandingMatches = demandingModelTypes.contains(demandingFactor);

    if (supportiveMatches && demandingMatches) {
      return 'You and Cal highlighted the same factors for increasing and decreasing your energy.';
    }
    if (supportiveMatches || demandingMatches) {
      return 'Part of your expectation matched what Cal highlighted.';
    }
    if (supportiveFactor == ForecastFactorType.outsideCalendar ||
        demandingFactor == ForecastFactorType.outsideCalendar) {
      return 'Your reflection adds context that the calendar cannot show.';
    }
    final seesOpposite =
        demandingModelTypes.contains(supportiveFactor) ||
        supportiveModelTypes.contains(demandingFactor);
    if (seesOpposite) {
      return 'You and Cal see part of today’s schedule differently.';
    }

    return 'You noticed something Cal did not highlight.';
  }
}
