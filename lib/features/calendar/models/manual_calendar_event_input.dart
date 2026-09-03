import 'calendar_event_category.dart';

class ManualCalendarEventInput {
  const ManualCalendarEventInput({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
  });

  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final CalendarEventCategory category;
}
