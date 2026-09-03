import '../../calendar/models/calendar_event.dart';
import '../../prediction/models/daily_calendar_features.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../../prediction/services/daily_feature_calculator.dart';
import '../models/daily_intention.dart';
import '../models/forecast_model_view.dart';
import '../models/forecast_reflection_option.dart';
import 'forecast_adjustment_catalog.dart';
import 'forecast_factor_mapper.dart';
import 'future_availability_service.dart';

class ForecastIntentionSuggestionService {
  const ForecastIntentionSuggestionService({
    this.featureCalculator = const DailyFeatureCalculator(),
    this.futureAvailabilityService = const FutureAvailabilityService(),
    this.factorMapper = const ForecastFactorMapper(),
    this.adjustmentCatalog = const ForecastAdjustmentCatalog(),
  });

  static const _noChange = DailyAdjustment(
    type: DailyAdjustmentType.noChange,
    label: 'No change today',
  );

  final DailyFeatureCalculator featureCalculator;
  final FutureAvailabilityService futureAvailabilityService;
  final ForecastFactorMapper factorMapper;
  final ForecastAdjustmentCatalog adjustmentCatalog;

  List<ForecastIntentionOption> build({
    required DateTime day,
    required List<CalendarEvent> events,
    required ForecastFactorOption supportiveFactor,
    required ForecastFactorOption demandingFactor,
    required ForecastModelView modelView,
    DateTime? now,
  }) {
    final scheduledEvents =
        events
            .where(
              (event) =>
                  !event.isAllDay && event.endTime.isAfter(event.startTime),
            )
            .toList()
          ..sort(
            (first, second) => first.startTime.compareTo(second.startTime),
          );
    final currentTime = now ?? DateTime.now();
    final futureSlots = futureAvailabilityService.availableSlots(
      day: day,
      events: scheduledEvents,
      now: currentTime,
    );
    final futureGapsBetweenActivities = futureAvailabilityService
        .gapsBetweenActivities(
          day: day,
          events: scheduledEvents,
          now: currentTime,
        );
    final breakStart = futureAvailabilityService
        .firstSlotWithDuration(futureSlots, 10)
        ?.startTime;
    final options = <ForecastIntentionOption>[];

    if (_canShapeIntention(demandingFactor.type)) {
      options.add(
        ForecastIntentionOption(
          sourceLabel: 'Based on what you noticed',
          factor: demandingFactor.toFactor(),
          adjustment: adjustmentCatalog.demandingAdjustment(
            type: demandingFactor.type,
            breakStart: breakStart,
          ),
        ),
      );
    } else if (demandingFactor.type == ForecastFactorType.outsideCalendar) {
      options.add(
        ForecastIntentionOption(
          sourceLabel: 'Based on what you noticed',
          factor: demandingFactor.toFactor(),
          adjustment: adjustmentCatalog.outsideCalendarAdjustment(breakStart),
        ),
      );
    }

    if (modelView.demandingSignals.isNotEmpty) {
      final attribution = modelView.demandingSignals.first;
      final type = factorMapper.typeForFeature(attribution.feature);
      options.add(
        ForecastIntentionOption(
          sourceLabel: 'Based on your forecast',
          factor: ForecastFactor(
            type: type,
            label: attribution.feature.displayLabel,
          ),
          adjustment: adjustmentCatalog.demandingAdjustment(
            type: type,
            breakStart: breakStart,
          ),
        ),
      );
    }

    options.addAll(
      _supportiveIntentionOptions(
        day: day,
        events: events,
        supportiveFactor: supportiveFactor,
        modelView: modelView,
        futureSlots: futureSlots,
        futureGapsBetweenActivities: futureGapsBetweenActivities,
      ),
    );

    options.add(
      const ForecastIntentionOption(
        sourceLabel: 'No adjustment',
        factor: ForecastFactor(
          type: ForecastFactorType.notSure,
          label: 'No specific factor',
        ),
        adjustment: _noChange,
      ),
    );

    final uniqueOptions = <ForecastIntentionOption>[];
    for (final option in options) {
      final duplicateIndex = uniqueOptions.indexWhere(
        (existing) =>
            existing.adjustment.type == option.adjustment.type &&
            existing.adjustment.label == option.adjustment.label &&
            existing.adjustment.startTime == option.adjustment.startTime &&
            existing.adjustment.endTime == option.adjustment.endTime,
      );
      if (duplicateIndex == -1) {
        uniqueOptions.add(option);
        continue;
      }

      final existing = uniqueOptions[duplicateIndex];
      uniqueOptions[duplicateIndex] = ForecastIntentionOption(
        sourceLabel: _mergeSourceLabels(
          existing.sourceLabel,
          option.sourceLabel,
        ),
        factor: existing.factor,
        adjustment: existing.adjustment,
        isRefreshable: existing.isRefreshable || option.isRefreshable,
      );
    }

    return uniqueOptions;
  }

  bool _canShapeIntention(ForecastFactorType type) {
    return factorMapper.featureForType(type) != null;
  }

  List<ForecastIntentionOption> _supportiveIntentionOptions({
    required DateTime day,
    required List<CalendarEvent> events,
    required ForecastFactorOption supportiveFactor,
    required ForecastModelView modelView,
    required List<FutureAvailabilitySlot> futureSlots,
    required List<FutureAvailabilitySlot> futureGapsBetweenActivities,
  }) {
    final features = featureCalculator.calculate(day: day, events: events);
    final modelFeatures = modelView.supportiveFeatures.toSet();
    final candidateFeatures = <EnergyModelFeature>[...modelFeatures];
    final userFeature = supportiveFactor.feature;
    if (userFeature != null && !candidateFeatures.contains(userFeature)) {
      candidateFeatures.add(userFeature);
    }

    final options = <ForecastIntentionOption>[];
    for (final feature in candidateFeatures) {
      if (!_canSuggestSupportiveFeature(
        feature,
        features,
        futureGapsBetweenActivities,
      )) {
        continue;
      }

      final factor = ForecastFactor(
        type: factorMapper.typeForFeature(feature),
        label: feature.displayLabel,
      );
      for (final adjustment in adjustmentCatalog.supportiveAdjustments(
        feature: feature,
        features: features,
        futureSlots: futureSlots,
        futureGapsBetweenActivities: futureGapsBetweenActivities,
      )) {
        options.add(
          ForecastIntentionOption(
            sourceLabel: _supportiveSourceLabel(
              isExpectedByUser: feature == userFeature,
              isSupportedByForecast: modelFeatures.contains(feature),
            ),
            factor: factor,
            adjustment: adjustment,
            isRefreshable: true,
          ),
        );
      }
    }

    options.addAll(adjustmentCatalog.generalOptions(futureSlots));

    final uniqueOptions = <ForecastIntentionOption>[];
    for (final option in options) {
      final alreadyAdded = uniqueOptions.any(
        (existing) =>
            existing.adjustment.type == option.adjustment.type &&
            existing.adjustment.label == option.adjustment.label &&
            existing.adjustment.startTime == option.adjustment.startTime &&
            existing.adjustment.endTime == option.adjustment.endTime,
      );
      if (!alreadyAdded) uniqueOptions.add(option);
    }

    return uniqueOptions;
  }

  String _supportiveSourceLabel({
    required bool isExpectedByUser,
    required bool isSupportedByForecast,
  }) {
    if (isExpectedByUser && isSupportedByForecast) {
      return 'Based on what you expect and your forecast';
    }
    if (isExpectedByUser) {
      return 'Based on what you expect may support you';
    }

    return 'Based on what your forecast identifies as supportive';
  }

  bool _canSuggestSupportiveFeature(
    EnergyModelFeature feature,
    DailyCalendarFeatures features,
    List<FutureAvailabilitySlot> futureGapsBetweenActivities,
  ) {
    return switch (feature) {
      EnergyModelFeature.busyMinutes => features.busyMinutes > 0,
      EnergyModelFeature.backToBackEventCount =>
        features.backToBackEventCount > 0,
      EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
        features.longestGapBetweenActivitiesMinutes > 0 &&
            futureAvailabilityService.firstSlotWithDuration(
                  futureGapsBetweenActivities,
                  10,
                ) !=
                null,
      EnergyModelFeature.maxConsecutiveBlockMinutes =>
        features.maxConsecutiveBlockMinutes > 0,
      EnergyModelFeature.focusMinutes ||
      EnergyModelFeature.socialMinutes ||
      EnergyModelFeature.lifeAdminMinutes ||
      EnergyModelFeature.exerciseMinutes => true,
    };
  }

  String _mergeSourceLabels(String first, String second) {
    const noticed = 'Based on what you noticed';
    const forecast = 'Based on your forecast';
    if ({first, second}.containsAll({noticed, forecast})) {
      return 'Based on what you noticed and your forecast';
    }

    return first;
  }
}
