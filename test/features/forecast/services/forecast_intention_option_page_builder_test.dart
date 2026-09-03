import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/models/forecast_reflection_option.dart';
import 'package:calendar_app/features/forecast/services/forecast_intention_option_page_builder.dart';

void main() {
  const builder = ForecastIntentionOptionPageBuilder();

  test('builds idea pages', () {
    final options = [
      _option(DailyAdjustmentType.quietPause, ForecastFactorType.notSure),
      _option(DailyAdjustmentType.shortWalk, ForecastFactorType.exercise),
      _option(DailyAdjustmentType.focusSession, ForecastFactorType.focusTime),
      _option(DailyAdjustmentType.socialMoment, ForecastFactorType.socialTime),
      _option(DailyAdjustmentType.noChange, ForecastFactorType.notSure),
    ];

    final result = builder.build(options);

    expect(result.pages, hasLength(2));
    expect(result.pages.first, hasLength(3));
    expect(result.pages.last, hasLength(3));
    expect(
      result.pages.expand((page) => page),
      isNot(contains(result.noChangeOption)),
    );
    expect(
      result.noChangeOption?.adjustment.type,
      DailyAdjustmentType.noChange,
    );
  });

  test('varies idea types', () {
    final pause = _option(
      DailyAdjustmentType.quietPause,
      ForecastFactorType.longestGapBetweenActivities,
    );
    final otherPause = _option(
      DailyAdjustmentType.screenBreak,
      ForecastFactorType.scheduledTime,
    );
    final movement = _option(
      DailyAdjustmentType.shortWalk,
      ForecastFactorType.exercise,
    );
    final social = _option(
      DailyAdjustmentType.socialMoment,
      ForecastFactorType.socialTime,
    );

    final firstPage = builder
        .build([pause, otherPause, movement, social])
        .pages
        .first;

    expect(firstPage, [pause, movement, social]);
  });

  test('finds selected page', () {
    final options = [
      _option(DailyAdjustmentType.quietPause, ForecastFactorType.notSure),
      _option(DailyAdjustmentType.shortWalk, ForecastFactorType.exercise),
      _option(DailyAdjustmentType.focusSession, ForecastFactorType.focusTime),
      _option(DailyAdjustmentType.socialMoment, ForecastFactorType.socialTime),
    ];
    final result = builder.build(options);

    expect(result.pageContaining(options.first), 0);
    expect(result.pageContaining(options.last), 1);
    expect(result.pageContaining(null), -1);
  });
}

ForecastIntentionOption _option(
  DailyAdjustmentType adjustmentType,
  ForecastFactorType factorType,
) {
  return ForecastIntentionOption(
    sourceLabel: factorType.name,
    factor: ForecastFactor(type: factorType, label: factorType.name),
    adjustment: DailyAdjustment(
      type: adjustmentType,
      label: adjustmentType.name,
    ),
  );
}
