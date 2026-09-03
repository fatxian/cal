import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/calendar/widgets/event_card.dart';

void main() {
  testWidgets('edits completed activity', (tester) async {
    CalendarEventCategory? selectedCategory;
    EventEnergyImpact? selectedImpact;
    final event = CalendarEvent(
      id: 'event-1',
      title: 'Study session',
      startTime: DateTime(2026, 7, 17, 9),
      endTime: DateTime(2026, 7, 17, 10),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EventCard(
              event: event,
              now: DateTime(2026, 7, 17, 11),
              onCategorySelected: (value) => selectedCategory = value,
              onEnergyImpactSelected: (value) => selectedImpact = value,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Choose a category'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(
      find.text('How did this activity affect your energy?'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('event-category-focus')));
    await tester.tap(find.byKey(const ValueKey('event-impact-increased')));

    expect(selectedCategory, CalendarEventCategory.focus);
    expect(selectedImpact, EventEnergyImpact.increased);
  });

  testWidgets('hides early energy question', (tester) async {
    final event = CalendarEvent(
      id: 'event-1',
      title: 'Study session',
      startTime: DateTime(2026, 7, 17, 12),
      endTime: DateTime(2026, 7, 17, 13),
      category: CalendarEventCategory.focus,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: event,
            now: DateTime(2026, 7, 17, 11),
            onCategorySelected: (_) {},
            onEnergyImpactSelected: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.text('How did this activity affect your energy?'),
      findsNothing,
    );
  });
}
