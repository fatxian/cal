import 'package:googleapis/calendar/v3.dart' as google_calendar;

import '../../categorisation/services/rule_based_category_service.dart';
import '../models/calendar_event.dart';

class GoogleCalendarEventMapper {
  GoogleCalendarEventMapper({RuleBasedCategoryService? categoryService})
    : categoryService = categoryService ?? const RuleBasedCategoryService();

  final RuleBasedCategoryService categoryService;

  CalendarEvent fromGoogleEvent(google_calendar.Event googleEvent) {
    final start = _readStartTime(googleEvent);
    final end = _readEndTime(googleEvent, start);
    final title = _readTitle(googleEvent);

    return CalendarEvent(
      id: 'google_${googleEvent.id ?? start.millisecondsSinceEpoch}',
      title: title,
      startTime: start,
      endTime: end,
      category: categoryService.suggestCategory(title),
      source: CalendarEventSource.google,
      externalId: googleEvent.id,
      isAllDay: googleEvent.start?.date != null,
    );
  }

  DateTime _readStartTime(google_calendar.Event googleEvent) {
    final start = googleEvent.start;
    final dateTime = start?.dateTime;
    final date = start?.date;

    if (dateTime != null) {
      return dateTime.toLocal();
    }

    if (date != null) {
      return DateTime(date.year, date.month, date.day);
    }

    return DateTime.now();
  }

  DateTime _readEndTime(google_calendar.Event googleEvent, DateTime start) {
    final end = googleEvent.end;
    final dateTime = end?.dateTime;
    final date = end?.date;

    if (dateTime != null) {
      return dateTime.toLocal();
    }

    if (date != null) {
      return DateTime(date.year, date.month, date.day);
    }

    return start.add(const Duration(hours: 1));
  }

  String _readTitle(google_calendar.Event googleEvent) {
    final summary = googleEvent.summary?.trim();

    if (summary == null || summary.isEmpty) {
      return '(No title)';
    }

    return summary;
  }
}
