import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/check_in/models/daily_reflection.dart';
import 'package:calendar_app/features/check_in/screens/daily_reflection_screen.dart';

void main() {
  testWidgets('starts at middle score', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: DailyReflectionScreen(day: DateTime(2020, 7, 17))),
    );

    expect(tester.widget<Slider>(find.byType(Slider)).value, 3);
    expect(find.text('Hanging in there'), findsOneWidget);
  });

  testWidgets('loads saved score', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DailyReflectionScreen(
          day: DateTime(2020, 7, 17),
          initialReflection: const DailyReflection(energyScore: 4),
        ),
      ),
    );

    expect(tester.widget<Slider>(find.byType(Slider)).value, 4);
    expect(find.text('Feeling good'), findsOneWidget);
  });

  testWidgets('shows incomplete activities', (tester) async {
    final updates = <CalendarEvent>[];
    final event = CalendarEvent(
      id: 'event-1',
      title: 'Study session',
      startTime: DateTime(2020, 7, 17, 9),
      endTime: DateTime(2020, 7, 17, 10),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DailyReflectionScreen(
          day: DateTime(2020, 7, 17),
          events: [event],
          onEventUpdated: (updatedEvent) async {
            updates.add(updatedEvent);
          },
        ),
      ),
    );

    expect(
      find.text('1 completed activity is ready to reflect on.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Review activities'));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('event-category-focus')));
    await tester.pump();
    expect(updates.last.category, CalendarEventCategory.focus);

    await tester.tap(find.byKey(const ValueKey('event-impact-increased')));
    await tester.pump();

    expect(updates.last.energyImpact, EventEnergyImpact.increased);
    expect(find.text('All completed activities are reviewed.'), findsOneWidget);
  });
}
