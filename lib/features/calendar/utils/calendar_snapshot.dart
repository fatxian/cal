import 'dart:convert';

import '../models/calendar_event.dart';

// build a stable key so Forecast can detect changes to the day's calendar
String createCalendarSnapshotKey(List<CalendarEvent> events) {
  final sortedEvents = List<CalendarEvent>.from(events)
    ..sort((first, second) {
      final startComparison = first.startTime.compareTo(second.startTime);
      if (startComparison != 0) return startComparison;

      return first.id.compareTo(second.id);
    });

  final snapshot = sortedEvents
      .map(
        (event) => {
          'source': event.source.name,
          'id': event.externalId ?? event.id,
          'title': event.title,
          'startTime': event.startTime.toUtc().toIso8601String(),
          'endTime': event.endTime.toUtc().toIso8601String(),
          'category': event.category?.name,
          'isAllDay': event.isAllDay,
        },
      )
      .toList();

  return jsonEncode(snapshot);
}
