import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/manual_calendar_event_input.dart';
import 'package:calendar_app/features/calendar/screens/manual_event_editor_screen.dart';

void main() {
  testWidgets('validates manual activity', (tester) async {
    ManualCalendarEventInput? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async {
                result = await Navigator.of(context)
                    .push<ManualCalendarEventInput>(
                      MaterialPageRoute(
                        builder: (context) =>
                            ManualEventEditorScreen(day: DateTime(2026, 6, 21)),
                      ),
                    );
              },
              child: const Text('Open editor'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save activity'));
    await tester.tap(find.text('Save activity'));
    await tester.pump();

    expect(find.text('Enter an activity name.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Study');
    await tester.ensureVisible(find.text('Save activity'));
    await tester.tap(find.text('Save activity'));
    await tester.pump();

    expect(find.text('Choose a category or Not sure.'), findsOneWidget);

    await tester.ensureVisible(find.text(CalendarEventCategory.focus.label));
    await tester.tap(find.text(CalendarEventCategory.focus.label));
    await tester.ensureVisible(find.text('Save activity'));
    await tester.tap(find.text('Save activity'));
    await tester.pumpAndSettle();

    expect(result?.title, 'Study');
    expect(result?.category, CalendarEventCategory.focus);
    expect(result?.startTime, DateTime(2026, 6, 21, 9));
    expect(result?.endTime, DateTime(2026, 6, 21, 10));
  });
}
