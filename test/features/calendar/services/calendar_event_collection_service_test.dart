import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_collection_service.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';
import 'package:calendar_app/features/calendar/services/manual_calendar_event_service.dart';

void main() {
  late AppDatabase database;
  late CalendarEventCollectionService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = CalendarEventCollectionService(
      syncedEventService: EventUserDataService(database: database),
      manualEventService: ManualCalendarEventService(database: database),
    );
  });

  tearDown(() => database.close());

  test('merges calendar events', () async {
    final day = DateTime(2026, 8, 2);
    final existingSyncedEvent = CalendarEvent(
      id: 'google:event-1',
      externalId: 'event-1',
      source: CalendarEventSource.google,
      title: 'Old title',
      startTime: DateTime(2026, 8, 2, 11),
      endTime: DateTime(2026, 8, 2, 12),
      category: CalendarEventCategory.focus,
      energyImpact: EventEnergyImpact.increased,
    );
    final manualEvent = CalendarEvent(
      id: 'manual-1',
      source: CalendarEventSource.manual,
      title: 'Manual activity',
      startTime: DateTime(2026, 8, 2, 9),
      endTime: DateTime(2026, 8, 2, 10),
      category: CalendarEventCategory.lifeAdmin,
    );
    final refreshedEvent = CalendarEvent(
      id: 'google:event-1',
      externalId: 'event-1',
      source: CalendarEventSource.google,
      title: 'Updated title',
      startTime: DateTime(2026, 8, 2, 11),
      endTime: DateTime(2026, 8, 2, 12),
    );

    final result = await service.prepareRefreshedEvents(
      refreshedSyncedEvents: [refreshedEvent],
      existingEvents: [existingSyncedEvent, manualEvent],
    );

    expect(result.syncedEvents.single.title, 'Updated title');
    expect(result.syncedEvents.single.category, CalendarEventCategory.focus);
    expect(
      result.syncedEvents.single.energyImpact,
      EventEnergyImpact.increased,
    );
    expect(result.allEvents.map((event) => event.id), [
      'manual-1',
      'google:event-1',
    ]);
    expect(result.allEvents.first.startTime.day, day.day);
  });
}
