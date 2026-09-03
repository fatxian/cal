import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/calendar_event.dart';
import '../models/calendar_event_category.dart';
import '../models/event_energy_impact.dart';

class EventUserDataService {
  const EventUserDataService({required this.database});

  final AppDatabase database;

  // load the last calendar events before asking google calendar again
  Future<List<CalendarEvent>> loadCachedEventsForDay(DateTime day) async {
    final rows =
        await (database.select(database.cachedCalendarEventItems)
              ..where((table) => table.date.equals(dateKey(day)))
              ..orderBy([(table) => OrderingTerm.asc(table.startTime)]))
            .get();
    final events = rows.map(_cachedRowToEvent).toList();

    return applySavedData(events);
  }

  // put the user's saved category and energy impact back onto loaded events
  Future<List<CalendarEvent>> applySavedData(List<CalendarEvent> events) async {
    if (events.isEmpty) {
      return events;
    }

    final eventKeys = events.map(_eventKey).toList();
    final savedRows = await (database.select(
      database.eventUserDataItems,
    )..where((table) => table.eventKey.isIn(eventKeys))).get();
    final rowsByKey = {for (final row in savedRows) row.eventKey: row};

    return events.map((event) {
      final savedRow = rowsByKey[_eventKey(event)];

      if (savedRow == null) {
        return event;
      }

      final isSameOccurrence = savedRow.date == dateKey(event.startTime);
      final savedEnergyImpact = isSameOccurrence
          ? EventEnergyImpact.fromScore(savedRow.energyImpactScore)
          : null;

      return event.copyWith(
        category: _decodeCategory(savedRow.category),
        clearCategory: savedRow.category == null,
        energyImpact: savedEnergyImpact,
        // category describes the event, but an energy response describes the
        // occurrence on the day when the user reflected on it
        clearEnergyImpact: savedEnergyImpact == null,
      );
    }).toList();
  }

  Future<void> saveEventUserData(CalendarEvent event) async {
    await database
        .into(database.eventUserDataItems)
        .insert(
          EventUserDataItemsCompanion.insert(
            eventKey: _eventKey(event),
            source: event.source.name,
            externalId: Value(event.externalId),
            date: dateKey(event.startTime),
            category: Value(event.category?.name),
            energyImpactScore: Value(event.energyImpact?.score),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> replaceCachedEventsForDay(
    DateTime day,
    List<CalendarEvent> events,
  ) async {
    final date = dateKey(day);

    await database.transaction(() async {
      await (database.delete(
        database.cachedCalendarEventItems,
      )..where((table) => table.date.equals(date))).go();

      for (final event in events) {
        await database
            .into(database.cachedCalendarEventItems)
            .insert(
              CachedCalendarEventItemsCompanion.insert(
                eventKey: _eventKey(event),
                source: event.source.name,
                externalId: Value(event.externalId),
                date: date,
                title: event.title,
                startTime: event.startTime,
                endTime: event.endTime,
                category: Value(event.category?.name),
                energyImpactScore: Value(event.energyImpact?.score),
                isAllDay: Value(event.isAllDay),
                updatedAt: Value(DateTime.now()),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  CalendarEvent _cachedRowToEvent(CachedCalendarEventItem row) {
    return CalendarEvent(
      id: row.eventKey,
      title: row.title,
      startTime: row.startTime,
      endTime: row.endTime,
      category: _decodeCategory(row.category),
      energyImpact: EventEnergyImpact.fromScore(row.energyImpactScore),
      source: _decodeSource(row.source),
      externalId: row.externalId,
      isAllDay: row.isAllDay,
    );
  }

  CalendarEventSource _decodeSource(String source) {
    return CalendarEventSource.values.firstWhere(
      (value) => value.name == source,
      orElse: () => CalendarEventSource.manual,
    );
  }

  String _eventKey(CalendarEvent event) {
    final externalKey = event.externalId ?? event.id;

    return '${event.source.name}:$externalKey';
  }

  CalendarEventCategory? _decodeCategory(String? category) {
    if (category == null) return null;

    return CalendarEventCategory.values.firstWhere(
      (value) => value.name == category,
    );
  }
}
