import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/calendar_event.dart';
import '../models/calendar_event_category.dart';
import '../models/event_energy_impact.dart';
import '../models/manual_calendar_event_input.dart';

class ManualCalendarEventService {
  const ManualCalendarEventService({required this.database});

  final AppDatabase database;

  Future<List<CalendarEvent>> loadEventsForDay(DateTime day) async {
    final rows =
        await (database.select(database.manualCalendarEventItems)
              ..where((table) => table.date.equals(dateKey(day)))
              ..orderBy([(table) => OrderingTerm.asc(table.startTime)]))
            .get();

    return rows.map(_rowToEvent).toList();
  }

  Future<CalendarEvent> createEvent(ManualCalendarEventInput input) async {
    final id = await database
        .into(database.manualCalendarEventItems)
        .insert(
          ManualCalendarEventItemsCompanion.insert(
            date: dateKey(input.startTime),
            title: input.title.trim(),
            startTime: input.startTime,
            endTime: input.endTime,
            category: input.category.name,
          ),
        );
    final row = await (database.select(
      database.manualCalendarEventItems,
    )..where((table) => table.id.equals(id))).getSingle();

    return _rowToEvent(row);
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final id = _databaseId(event);

    await (database.update(
      database.manualCalendarEventItems,
    )..where((table) => table.id.equals(id))).write(
      ManualCalendarEventItemsCompanion(
        date: Value(dateKey(event.startTime)),
        title: Value(event.title.trim()),
        startTime: Value(event.startTime),
        endTime: Value(event.endTime),
        category: Value((event.category ?? CalendarEventCategory.notSure).name),
        energyImpactScore: Value(event.energyImpact?.score),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteEvent(CalendarEvent event) async {
    final id = _databaseId(event);
    await (database.delete(
      database.manualCalendarEventItems,
    )..where((table) => table.id.equals(id))).go();
  }

  CalendarEvent _rowToEvent(ManualCalendarEventItem row) {
    return CalendarEvent(
      id: 'manual-${row.id}',
      title: row.title,
      startTime: row.startTime,
      endTime: row.endTime,
      category: _decodeCategory(row.category),
      energyImpact: EventEnergyImpact.fromScore(row.energyImpactScore),
      source: CalendarEventSource.manual,
    );
  }

  int _databaseId(CalendarEvent event) {
    if (event.source != CalendarEventSource.manual ||
        !event.id.startsWith('manual-')) {
      throw ArgumentError.value(event.id, 'event', 'Not a manual event');
    }

    final id = int.tryParse(event.id.substring('manual-'.length));
    if (id == null) {
      throw ArgumentError.value(event.id, 'event', 'Invalid manual event ID');
    }

    return id;
  }

  CalendarEventCategory _decodeCategory(String category) {
    return CalendarEventCategory.values.firstWhere(
      (value) => value.name == category,
      orElse: () => CalendarEventCategory.notSure,
    );
  }
}
