import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';

void main() {
  test('keeps saved category', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventUserDataService = EventUserDataService(database: database);
    addTearDown(database.close);

    final automaticallyCategorisedEvent = CalendarEvent(
      id: 'event-1',
      title: 'Team meeting',
      startTime: DateTime(2026, 6, 26, 9),
      endTime: DateTime(2026, 6, 26, 10),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'google-event-1',
    );
    final userEditedEvent = automaticallyCategorisedEvent.copyWith(
      category: CalendarEventCategory.social,
    );

    await eventUserDataService.saveEventUserData(userEditedEvent);
    final events = await eventUserDataService.applySavedData([
      automaticallyCategorisedEvent,
    ]);

    expect(events.single.category, CalendarEventCategory.social);
  });

  test('keeps cleared category', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventUserDataService = EventUserDataService(database: database);
    addTearDown(database.close);

    final automaticallyCategorisedEvent = CalendarEvent(
      id: 'event-1',
      title: 'Team meeting',
      startTime: DateTime(2026, 6, 26, 9),
      endTime: DateTime(2026, 6, 26, 10),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'google-event-1',
    );
    final clearedEvent = automaticallyCategorisedEvent.copyWith(
      clearCategory: true,
    );

    await eventUserDataService.saveEventUserData(clearedEvent);
    final events = await eventUserDataService.applySavedData([
      automaticallyCategorisedEvent,
    ]);

    expect(events.single.category, isNull);
  });

  test('handles duplicate events', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventUserDataService = EventUserDataService(database: database);
    addTearDown(database.close);

    final firstEvent = CalendarEvent(
      id: 'event-1',
      title: 'Work',
      startTime: DateTime(2026, 7, 17, 13),
      endTime: DateTime(2026, 7, 17, 14),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'google-event-1',
    );
    final updatedDuplicate = firstEvent.copyWith(
      title: 'Updated work',
      endTime: DateTime(2026, 7, 17, 14, 30),
    );

    await eventUserDataService.replaceCachedEventsForDay(
      DateTime(2026, 7, 17),
      [firstEvent, updatedDuplicate],
    );

    final cachedEvents = await eventUserDataService.loadCachedEventsForDay(
      DateTime(2026, 7, 17),
    );

    expect(cachedEvents, hasLength(1));
    expect(cachedEvents.single.title, 'Updated work');
    expect(cachedEvents.single.endTime, DateTime(2026, 7, 17, 14, 30));
  });

  test('saves energy response', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventUserDataService = EventUserDataService(database: database);
    addTearDown(database.close);

    final event = CalendarEvent(
      id: 'event-1',
      title: 'Study session',
      startTime: DateTime(2026, 7, 17, 13),
      endTime: DateTime(2026, 7, 17, 14),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'google-event-1',
    );

    await eventUserDataService.saveEventUserData(
      event.copyWith(energyImpact: EventEnergyImpact.decreased),
    );
    final restored = await eventUserDataService.applySavedData([event]);

    expect(restored.single.energyImpact, EventEnergyImpact.decreased);
  });

  test('keeps response date', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventUserDataService = EventUserDataService(database: database);
    addTearDown(database.close);

    final originalEvent = CalendarEvent(
      id: 'event-1',
      title: 'Study session',
      startTime: DateTime(2026, 7, 17, 13),
      endTime: DateTime(2026, 7, 17, 14),
      category: CalendarEventCategory.focus,
      energyImpact: EventEnergyImpact.decreased,
      source: CalendarEventSource.google,
      externalId: 'google-event-1',
    );
    await eventUserDataService.saveEventUserData(originalEvent);

    final movedEvent = originalEvent.copyWith(
      startTime: DateTime(2026, 7, 18, 13),
      endTime: DateTime(2026, 7, 18, 14),
      clearCategory: true,
      clearEnergyImpact: true,
    );
    final restored = await eventUserDataService.applySavedData([movedEvent]);

    expect(restored.single.category, CalendarEventCategory.focus);
    expect(restored.single.energyImpact, isNull);
  });
}
