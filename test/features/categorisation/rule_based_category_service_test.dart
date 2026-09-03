import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/calendar/v3.dart' as google_calendar;

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/services/google_calendar_event_mapper.dart';
import 'package:calendar_app/features/categorisation/services/rule_based_category_service.dart';

void main() {
  const categoryService = RuleBasedCategoryService();

  group('RuleBasedCategoryService', () {
    test('classifies lecture', () {
      expect(
        categoryService.suggestCategory('COMSM Lecture'),
        CalendarEventCategory.focus,
      );
    });

    test('classifies group meeting', () {
      expect(
        categoryService.suggestCategory('Group project meeting'),
        CalendarEventCategory.focus,
      );
    });

    test('classifies gym', () {
      expect(
        categoryService.suggestCategory('Gym session'),
        CalendarEventCategory.exercise,
      );
    });

    test('classifies social dinner', () {
      expect(
        categoryService.suggestCategory('Dinner with friends'),
        CalendarEventCategory.social,
      );
    });

    test('classifies dentist', () {
      expect(
        categoryService.suggestCategory('Dentist appointment'),
        CalendarEventCategory.lifeAdmin,
      );
    });

    test('classifies break', () {
      expect(
        categoryService.suggestCategory('Afternoon break'),
        CalendarEventCategory.rest,
      );
    });

    test('handles unknown activity', () {
      expect(categoryService.suggestCategory('Random event'), isNull);
    });

    test('normalises event title', () {
      expect(
        categoryService.suggestCategory('  GYM: SESSION  '),
        CalendarEventCategory.exercise,
      );
    });
  });

  group('GoogleCalendarEventMapper', () {
    test('maps Google event', () {
      final googleEvent = google_calendar.Event()
        ..id = 'event-1'
        ..summary = 'Gym session'
        ..start = (google_calendar.EventDateTime()
          ..dateTime = DateTime(2026, 6, 26, 9))
        ..end = (google_calendar.EventDateTime()
          ..dateTime = DateTime(2026, 6, 26, 10));

      final calendarEvent = GoogleCalendarEventMapper().fromGoogleEvent(
        googleEvent,
      );

      expect(calendarEvent.source, CalendarEventSource.google);
      expect(calendarEvent.externalId, 'event-1');
      expect(calendarEvent.title, 'Gym session');
      expect(calendarEvent.category, CalendarEventCategory.exercise);
    });
  });
}
