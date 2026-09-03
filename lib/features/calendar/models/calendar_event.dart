import 'calendar_event_category.dart';
import 'event_energy_impact.dart';

enum CalendarEventSource { mock, google, outlook, manual }

class CalendarEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final CalendarEventCategory? category;
  final EventEnergyImpact? energyImpact;
  final CalendarEventSource source;
  final String? externalId;
  final bool isAllDay;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.category,
    this.energyImpact,
    this.source = CalendarEventSource.mock,
    this.externalId,
    this.isAllDay = false,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    CalendarEventCategory? category,
    bool clearCategory = false,
    EventEnergyImpact? energyImpact,
    bool clearEnergyImpact = false,
    CalendarEventSource? source,
    String? externalId,
    bool? isAllDay,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: clearCategory ? null : category ?? this.category,
      energyImpact: clearEnergyImpact
          ? null
          : energyImpact ?? this.energyImpact,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }
}
