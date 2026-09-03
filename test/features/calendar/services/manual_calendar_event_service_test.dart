import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/calendar/models/manual_calendar_event_input.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_collection_service.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';
import 'package:calendar_app/features/calendar/services/manual_calendar_event_service.dart';

void main() {
  late AppDatabase database;
  late EventUserDataService syncedEventService;
  late ManualCalendarEventService manualEventService;
  late CalendarEventCollectionService collectionService;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    syncedEventService = EventUserDataService(database: database);
    manualEventService = ManualCalendarEventService(database: database);
    collectionService = CalendarEventCollectionService(
      syncedEventService: syncedEventService,
      manualEventService: manualEventService,
    );
  });

  tearDown(() => database.close());

  test('manages manual activity', () async {
    final day = DateTime(2026, 7, 21);
    final created = await manualEventService.createEvent(
      ManualCalendarEventInput(
        title: 'Walk',
        startTime: DateTime(2026, 7, 21, 12),
        endTime: DateTime(2026, 7, 21, 12, 30),
        category: CalendarEventCategory.exercise,
      ),
    );

    expect(created.source, CalendarEventSource.manual);
    expect(created.category, CalendarEventCategory.exercise);

    final updated = created.copyWith(
      title: 'Lunch walk',
      category: CalendarEventCategory.social,
      energyImpact: EventEnergyImpact.increased,
    );
    await manualEventService.updateEvent(updated);

    final saved = await manualEventService.loadEventsForDay(day);
    expect(saved, hasLength(1));
    expect(saved.single.title, 'Lunch walk');
    expect(saved.single.category, CalendarEventCategory.social);
    expect(saved.single.energyImpact, EventEnergyImpact.increased);

    await manualEventService.deleteEvent(saved.single);
    expect(await manualEventService.loadEventsForDay(day), isEmpty);
  });

  test('keeps manual activities', () async {
    final day = DateTime(2026, 7, 21);
    await manualEventService.createEvent(
      ManualCalendarEventInput(
        title: 'Manual activity',
        startTime: DateTime(2026, 7, 21, 9),
        endTime: DateTime(2026, 7, 21, 10),
        category: CalendarEventCategory.lifeAdmin,
      ),
    );
    await syncedEventService.replaceCachedEventsForDay(day, [
      CalendarEvent(
        id: 'google-1',
        title: 'Synced activity',
        startTime: DateTime(2026, 7, 21, 13),
        endTime: DateTime(2026, 7, 21, 14),
        category: CalendarEventCategory.focus,
        source: CalendarEventSource.google,
        externalId: 'google-1',
      ),
    ]);

    var events = await collectionService.loadEventsForDay(day);
    expect(events.map((event) => event.title), [
      'Manual activity',
      'Synced activity',
    ]);

    await syncedEventService.replaceCachedEventsForDay(day, []);
    events = await collectionService.loadEventsForDay(day);

    expect(events, hasLength(1));
    expect(events.single.title, 'Manual activity');
    expect(events.single.source, CalendarEventSource.manual);
  });
}
