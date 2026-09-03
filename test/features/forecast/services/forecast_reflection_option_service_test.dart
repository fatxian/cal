import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/models/forecast_model_view.dart';
import 'package:calendar_app/features/forecast/models/forecast_reflection_option.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_option_service.dart';
import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';

void main() {
  const service = ForecastReflectionOptionService();
  final day = DateTime(2026, 6, 30);

  test('lists present factors', () {
    final options = service.buildForecastFactorOptions(
      day: day,
      events: [
        CalendarEvent(
          id: 'focus',
          title: 'Study',
          startTime: DateTime(2026, 6, 30, 9),
          endTime: DateTime(2026, 6, 30, 10),
          category: CalendarEventCategory.focus,
        ),
        CalendarEvent(
          id: 'exercise',
          title: 'Exercise',
          startTime: DateTime(2026, 6, 30, 10, 10),
          endTime: DateTime(2026, 6, 30, 11),
          category: CalendarEventCategory.exercise,
        ),
      ],
    );

    expect(
      options.map((option) => option.type),
      containsAll([
        ForecastFactorType.scheduledTime,
        ForecastFactorType.backToBackEvents,
        ForecastFactorType.longestGapBetweenActivities,
        ForecastFactorType.longestScheduledBlock,
        ForecastFactorType.focusTime,
        ForecastFactorType.exercise,
        ForecastFactorType.outsideCalendar,
        ForecastFactorType.nothingStandsOut,
        ForecastFactorType.notSure,
      ]),
    );
  });

  test('separates contribution directions', () {
    const features = DailyCalendarFeatures(
      totalEventCount: 2,
      allDayEventCount: 0,
      totalScheduledMinutes: 120,
      busyMinutes: 120,
      focusMinutes: 60,
      socialMinutes: 0,
      lifeAdminMinutes: 0,
      exerciseMinutes: 60,
      restMinutes: 0,
      backToBackEventCount: 0,
      freeMinutes: 720,
      longestGapBetweenActivitiesMinutes: 300,
      maxConsecutiveBlockMinutes: 60,
      freeSlots: [],
    );

    final view = service.buildModelView(
      features: features,
      modelParameters: _modelWith({
        EnergyModelFeature.focusMinutes: 1,
        EnergyModelFeature.exerciseMinutes: -1,
      }),
    );

    expect(
      view.demandingSignals.map((signal) => signal.feature),
      contains(EnergyModelFeature.focusMinutes),
    );
    expect(
      view.supportiveSignals.map((signal) => signal.feature),
      contains(EnergyModelFeature.exerciseMinutes),
    );
    expect(view.supportiveSignals, hasLength(1));
    expect(view.demandingSignals, hasLength(1));
  });

  test('builds intention choices', () {
    final options = service.buildIntentionOptions(
      day: day,
      now: DateTime(2026, 6, 30, 12),
      events: [
        CalendarEvent(
          id: 'focus',
          title: 'Study',
          startTime: DateTime(2026, 6, 30, 13),
          endTime: DateTime(2026, 6, 30, 15),
          category: CalendarEventCategory.focus,
        ),
      ],
      supportiveFactor: const ForecastFactorOption(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
        feature: EnergyModelFeature.exerciseMinutes,
      ),
      demandingFactor: const ForecastFactorOption(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
        feature: EnergyModelFeature.focusMinutes,
      ),
      modelView: const ForecastModelView(
        supportiveSignals: [],
        demandingSignals: [],
      ),
    );

    expect(
      options.map((option) => option.sourceLabel),
      containsAll([
        'Based on what you noticed',
        'Based on what you expect may support you',
        'No adjustment',
      ]),
    );
    expect(options.last.adjustment.type, DailyAdjustmentType.noChange);
  });

  test('refreshes intention choices', () {
    final options = service.buildIntentionOptions(
      day: day,
      now: DateTime(2026, 6, 30, 12),
      events: [
        CalendarEvent(
          id: 'focus',
          title: 'Study',
          startTime: DateTime(2026, 6, 30, 13),
          endTime: DateTime(2026, 6, 30, 15),
          category: CalendarEventCategory.focus,
        ),
      ],
      supportiveFactor: const ForecastFactorOption(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
        feature: EnergyModelFeature.focusMinutes,
      ),
      demandingFactor: const ForecastFactorOption(
        type: ForecastFactorType.nothingStandsOut,
        label: 'Nothing stands out',
      ),
      modelView: const ForecastModelView(
        supportiveSignals: [],
        demandingSignals: [],
        supportiveFeatures: [
          EnergyModelFeature.exerciseMinutes,
          EnergyModelFeature.socialMinutes,
        ],
      ),
    );

    final supportiveOptions = options
        .where((option) => option.isRefreshable)
        .toList();

    expect(
      supportiveOptions.map((option) => option.factor.type).toSet(),
      containsAll({
        ForecastFactorType.exercise,
        ForecastFactorType.socialTime,
        ForecastFactorType.focusTime,
      }),
    );
    expect(
      supportiveOptions
          .where((option) => option.factor.type == ForecastFactorType.focusTime)
          .every(
            (option) =>
                option.sourceLabel ==
                'Based on what you expect may support you',
          ),
      isTrue,
    );
    expect(
      supportiveOptions
          .where(
            (option) =>
                option.factor.type == ForecastFactorType.exercise ||
                option.factor.type == ForecastFactorType.socialTime,
          )
          .every(
            (option) =>
                option.sourceLabel ==
                'Based on what your forecast identifies as supportive',
          ),
      isTrue,
    );
    expect(
      supportiveOptions
          .where((option) => option.factor.type == ForecastFactorType.exercise)
          .length,
      greaterThanOrEqualTo(2),
    );
    expect(
      supportiveOptions
          .where((option) => option.sourceLabel == 'A general option')
          .length,
      3,
    );
  });

  test('ignores past gaps', () {
    final options = service.buildIntentionOptions(
      day: day,
      now: DateTime(2026, 6, 30, 16),
      events: [
        CalendarEvent(
          id: 'morning',
          title: 'Morning activity',
          startTime: DateTime(2026, 6, 30, 9),
          endTime: DateTime(2026, 6, 30, 10),
        ),
        CalendarEvent(
          id: 'afternoon',
          title: 'Afternoon activity',
          startTime: DateTime(2026, 6, 30, 13),
          endTime: DateTime(2026, 6, 30, 14),
        ),
      ],
      supportiveFactor: const ForecastFactorOption(
        type: ForecastFactorType.notSure,
        label: 'Not sure',
      ),
      demandingFactor: const ForecastFactorOption(
        type: ForecastFactorType.nothingStandsOut,
        label: 'Nothing stands out',
      ),
      modelView: const ForecastModelView(
        supportiveSignals: [],
        demandingSignals: [],
        supportiveFeatures: [
          EnergyModelFeature.longestGapBetweenActivitiesMinutes,
        ],
      ),
    );

    final supportiveOptions = options.where((option) => option.isRefreshable);
    expect(supportiveOptions.map((option) => option.factor.type).toSet(), {
      ForecastFactorType.notSure,
    });
    expect(
      supportiveOptions.map((option) => option.adjustment.label),
      isNot(contains('Keep a long gap between activities open')),
    );
  });

  test('handles no future slot', () {
    final options = service.buildIntentionOptions(
      day: day,
      now: DateTime(2026, 6, 30, 22, 5),
      events: const [],
      supportiveFactor: const ForecastFactorOption(
        type: ForecastFactorType.notSure,
        label: 'Not sure',
      ),
      demandingFactor: const ForecastFactorOption(
        type: ForecastFactorType.outsideCalendar,
        label: 'Something outside my schedule',
      ),
      modelView: const ForecastModelView(
        supportiveSignals: [],
        demandingSignals: [],
      ),
    );

    expect(options, isNotEmpty);
    expect(
      options.every(
        (option) =>
            option.adjustment.startTime == null &&
            option.adjustment.endTime == null,
      ),
      isTrue,
    );
    expect(
      options.map((option) => option.adjustment.label).join(' '),
      isNot(contains('22:')),
    );
  });

  test('compares energy directions', () {
    const features = DailyCalendarFeatures(
      totalEventCount: 2,
      allDayEventCount: 0,
      totalScheduledMinutes: 120,
      busyMinutes: 120,
      focusMinutes: 60,
      socialMinutes: 0,
      lifeAdminMinutes: 0,
      exerciseMinutes: 60,
      restMinutes: 0,
      backToBackEventCount: 0,
      freeMinutes: 720,
      longestGapBetweenActivitiesMinutes: 300,
      maxConsecutiveBlockMinutes: 60,
      freeSlots: [],
    );
    final view = service.buildModelView(
      features: features,
      modelParameters: _modelWith({
        EnergyModelFeature.focusMinutes: 1,
        EnergyModelFeature.exerciseMinutes: -1,
      }),
    );

    expect(
      service.comparisonMessage(
        supportiveFactor: ForecastFactorType.exercise,
        demandingFactor: ForecastFactorType.focusTime,
        modelView: view,
      ),
      'You and Cal highlighted the same factors for increasing and decreasing your energy.',
    );
    expect(
      service.comparisonMessage(
        supportiveFactor: ForecastFactorType.focusTime,
        demandingFactor: ForecastFactorType.exercise,
        modelView: view,
      ),
      'You and Cal see part of today’s schedule differently.',
    );
  });

  test('merges matching intentions', () {
    final model = _modelWith({EnergyModelFeature.focusMinutes: 1});
    const features = DailyCalendarFeatures(
      totalEventCount: 1,
      allDayEventCount: 0,
      totalScheduledMinutes: 120,
      busyMinutes: 120,
      focusMinutes: 120,
      socialMinutes: 0,
      lifeAdminMinutes: 0,
      exerciseMinutes: 0,
      restMinutes: 0,
      backToBackEventCount: 0,
      freeMinutes: 720,
      longestGapBetweenActivitiesMinutes: 300,
      maxConsecutiveBlockMinutes: 120,
      freeSlots: [],
    );
    final view = service.buildModelView(
      features: features,
      modelParameters: model,
    );
    final options = service.buildIntentionOptions(
      day: day,
      now: DateTime(2026, 6, 30, 12),
      events: [
        CalendarEvent(
          id: 'focus',
          title: 'Study',
          startTime: DateTime(2026, 6, 30, 13),
          endTime: DateTime(2026, 6, 30, 15),
          category: CalendarEventCategory.focus,
        ),
      ],
      supportiveFactor: const ForecastFactorOption(
        type: ForecastFactorType.nothingStandsOut,
        label: 'Nothing stands out',
      ),
      demandingFactor: const ForecastFactorOption(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
        feature: EnergyModelFeature.focusMinutes,
      ),
      modelView: view,
    );

    expect(
      options.first.sourceLabel,
      'Based on what you noticed and your forecast',
    );
  });
}

LogisticModelParameters _modelWith(Map<EnergyModelFeature, double> weights) {
  return LogisticModelParameters(
    featureVersion: EnergyModelContract.featureVersion,
    targetVersion: EnergyModelContract.targetVersion,
    modelVersion: 'test-model',
    intercept: 0,
    coefficients: {
      for (final feature in EnergyModelContract.orderedFeatures)
        feature: weights[feature] ?? 0,
    },
  );
}
