import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/models/forecast_reflection_option.dart';
import 'package:calendar_app/features/forecast/widgets/forecast_intention_section.dart';

void main() {
  testWidgets('shows intention ideas', (tester) async {
    const exerciseOption = ForecastIntentionOption(
      sourceLabel: 'Based on what you expect may support you',
      factor: ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise time',
      ),
      adjustment: DailyAdjustment(
        type: DailyAdjustmentType.shortWalk,
        label: 'Take a short walk',
      ),
    );
    const options = [
      ForecastIntentionOption(
        sourceLabel: 'Based on what you noticed',
        factor: ForecastFactor(
          type: ForecastFactorType.focusTime,
          label: 'Focused activities',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.focusSession,
          label: 'Choose one main focus task',
        ),
      ),
      ForecastIntentionOption(
        sourceLabel: 'Based on your forecast',
        factor: ForecastFactor(
          type: ForecastFactorType.scheduledTime,
          label: 'Total scheduled time',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label: 'Move one lower-priority activity',
        ),
      ),
      exerciseOption,
      ForecastIntentionOption(
        sourceLabel: 'A general option',
        factor: ForecastFactor(
          type: ForecastFactorType.notSure,
          label: 'General wellbeing',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.quietPause,
          label: 'Take a quiet pause',
        ),
      ),
      ForecastIntentionOption(
        sourceLabel: 'No adjustment',
        factor: ForecastFactor(
          type: ForecastFactorType.notSure,
          label: 'No specific factor',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.noChange,
          label: 'No change today',
        ),
      ),
    ];
    ForecastIntentionOption? selectedOption;
    DailyIntention? intention;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: ForecastIntentionSection(
                intentionOptions: options,
                isLoading: false,
                selectedIntentionOption: selectedOption,
                dailyIntention: intention,
                hasCalendarChanged: false,
                isEditingIntention: false,
                onIntentionSelected: (option) {
                  setState(() {
                    selectedOption = option;
                    intention = DailyIntention(
                      factor: option.factor,
                      adjustment: option.adjustment,
                      calendarSnapshotKey: 'snapshot',
                    );
                  });
                },
                onReview: () {},
                onKeepCurrent: () {},
                onEdit: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Choose one main focus task'), findsOneWidget);
    expect(find.text('Move one lower-priority activity'), findsOneWidget);
    expect(find.text('Take a short walk'), findsOneWidget);
    expect(find.text('Take a quiet pause'), findsNothing);
    expect(find.text('No change today'), findsOneWidget);

    await tester.tap(find.text('Take a short walk'));
    await tester.pumpAndSettle();

    expect(find.text('Your intention for today'), findsOneWidget);
    expect(find.text('Take a short walk'), findsOneWidget);
    expect(
      find.text(
        'Exercise time was one of the factors you expected could increase your energy today.',
      ),
      findsOneWidget,
    );
    expect(find.text('What intention would you like to set?'), findsNothing);
  });

  testWidgets('handles calendar change', (tester) async {
    var reviewed = false;
    var keptCurrent = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ForecastIntentionSection(
            intentionOptions: const [],
            isLoading: false,
            selectedIntentionOption: null,
            dailyIntention: const DailyIntention(
              factor: ForecastFactor(
                type: ForecastFactorType.focusTime,
                label: 'Focused activities',
              ),
              adjustment: DailyAdjustment(
                type: DailyAdjustmentType.focusSession,
                label: 'Choose one main focus task',
              ),
              calendarSnapshotKey: 'old-snapshot',
            ),
            hasCalendarChanged: true,
            isEditingIntention: false,
            onIntentionSelected: (_) {},
            onReview: () => reviewed = true,
            onKeepCurrent: () => keptCurrent = true,
            onEdit: () {},
          ),
        ),
      ),
    );

    expect(find.widgetWithText(FilledButton, 'Review'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Keep current'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await tester.tap(find.text('Keep current'));

    expect(reviewed, isTrue);
    expect(keptCurrent, isTrue);
  });
}
