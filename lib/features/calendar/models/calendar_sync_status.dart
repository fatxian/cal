import 'calendar_event.dart';

class CalendarSyncStatus {
  const CalendarSyncStatus({
    required this.day,
    required this.source,
    required this.lastSuccessfulSyncAt,
    required this.eventCount,
  });

  final DateTime day;
  final CalendarEventSource source;
  final DateTime lastSuccessfulSyncAt;
  final int eventCount;
}
