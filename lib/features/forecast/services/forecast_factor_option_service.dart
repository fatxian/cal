import '../../calendar/models/calendar_event.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/services/daily_feature_calculator.dart';
import '../models/daily_intention.dart';
import '../models/forecast_reflection_option.dart';

class ForecastFactorOptionService {
  const ForecastFactorOptionService({
    this.featureCalculator = const DailyFeatureCalculator(),
  });

  final DailyFeatureCalculator featureCalculator;

  List<ForecastFactorOption> build({
    required DateTime day,
    required List<CalendarEvent> events,
  }) {
    final features = featureCalculator.calculate(day: day, events: events);
    final options = <ForecastFactorOption>[];

    void addFeature(
      ForecastFactorType type,
      EnergyModelFeature feature,
      num value,
    ) {
      if (value == 0) return;
      options.add(
        ForecastFactorOption(
          type: type,
          label: feature.displayLabel,
          feature: feature,
        ),
      );
    }

    addFeature(
      ForecastFactorType.scheduledTime,
      EnergyModelFeature.busyMinutes,
      features.busyMinutes,
    );
    addFeature(
      ForecastFactorType.backToBackEvents,
      EnergyModelFeature.backToBackEventCount,
      features.backToBackEventCount,
    );
    if (features.totalEventCount > 0) {
      addFeature(
        ForecastFactorType.longestGapBetweenActivities,
        EnergyModelFeature.longestGapBetweenActivitiesMinutes,
        features.longestGapBetweenActivitiesMinutes,
      );
    }
    addFeature(
      ForecastFactorType.longestScheduledBlock,
      EnergyModelFeature.maxConsecutiveBlockMinutes,
      features.maxConsecutiveBlockMinutes,
    );
    addFeature(
      ForecastFactorType.focusTime,
      EnergyModelFeature.focusMinutes,
      features.focusMinutes,
    );
    addFeature(
      ForecastFactorType.socialTime,
      EnergyModelFeature.socialMinutes,
      features.socialMinutes,
    );
    addFeature(
      ForecastFactorType.lifeAdminTasks,
      EnergyModelFeature.lifeAdminMinutes,
      features.lifeAdminMinutes,
    );
    addFeature(
      ForecastFactorType.exercise,
      EnergyModelFeature.exerciseMinutes,
      features.exerciseMinutes,
    );

    options.addAll(const [
      ForecastFactorOption(
        type: ForecastFactorType.outsideCalendar,
        label: 'Something outside my schedule',
      ),
      ForecastFactorOption(
        type: ForecastFactorType.nothingStandsOut,
        label: 'Nothing stands out',
      ),
      ForecastFactorOption(type: ForecastFactorType.notSure, label: 'Not sure'),
    ]);

    return options;
  }
}
