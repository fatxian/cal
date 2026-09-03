import '../models/calendar_event.dart';
import '../models/manual_calendar_event_input.dart';
import 'event_user_data_service.dart';
import 'manual_calendar_event_service.dart';

class CalendarEventCollectionService {
  const CalendarEventCollectionService({
    required this.syncedEventService,
    required this.manualEventService,
  });

  final EventUserDataService syncedEventService;
  final ManualCalendarEventService manualEventService;

  Future<List<CalendarEvent>> loadEventsForDay(DateTime day) async {
    final results = await Future.wait([
      syncedEventService.loadCachedEventsForDay(day),
      manualEventService.loadEventsForDay(day),
    ]);
    final events = [...results[0], ...results[1]];
    return sortEvents(events);
  }

  Future<CalendarEventRefreshResult> prepareRefreshedEvents({
    required List<CalendarEvent> refreshedSyncedEvents,
    required List<CalendarEvent> existingEvents,
  }) async {
    // preserve categories and energy responses entered in Cal when refreshed
    // Google event data replaces the cached event details
    final mergedSyncedEvents = refreshedSyncedEvents
        .map(
          (event) =>
              _mergeLocalEventState(event, existingEvents: existingEvents),
        )
        .toList();
    final syncedEventsWithSavedData = await syncedEventService.applySavedData(
      mergedSyncedEvents,
    );
    final manualEvents = existingEvents.where(
      (event) => event.source == CalendarEventSource.manual,
    );

    // keep manual activities separate from replacement of the Google cache
    return CalendarEventRefreshResult(
      syncedEvents: syncedEventsWithSavedData,
      allEvents: sortEvents([...syncedEventsWithSavedData, ...manualEvents]),
    );
  }

  Future<CalendarEvent> createManualEvent(ManualCalendarEventInput input) {
    return manualEventService.createEvent(input);
  }

  Future<void> saveEventChanges(CalendarEvent event) {
    if (event.source == CalendarEventSource.manual) {
      return manualEventService.updateEvent(event);
    }

    return syncedEventService.saveEventUserData(event);
  }

  Future<void> replaceSyncedEventsForDay(
    DateTime day,
    List<CalendarEvent> events,
  ) {
    return syncedEventService.replaceCachedEventsForDay(day, events);
  }

  Future<void> deleteManualEvent(CalendarEvent event) {
    return manualEventService.deleteEvent(event);
  }

  List<CalendarEvent> sortEvents(Iterable<CalendarEvent> events) {
    return [...events]..sort(_compareEvents);
  }

  CalendarEvent _mergeLocalEventState(
    CalendarEvent refreshedEvent, {
    required List<CalendarEvent> existingEvents,
  }) {
    CalendarEvent? existingEvent;

    for (final event in existingEvents) {
      if (event.id == refreshedEvent.id ||
          (event.externalId != null &&
              event.externalId == refreshedEvent.externalId)) {
        existingEvent = event;
        break;
      }
    }

    if (existingEvent == null) return refreshedEvent;

    return refreshedEvent.copyWith(
      category: existingEvent.category,
      clearCategory: existingEvent.category == null,
      energyImpact: existingEvent.energyImpact,
    );
  }

  int _compareEvents(CalendarEvent first, CalendarEvent second) {
    final startComparison = first.startTime.compareTo(second.startTime);
    if (startComparison != 0) return startComparison;

    final endComparison = first.endTime.compareTo(second.endTime);
    if (endComparison != 0) return endComparison;

    return first.id.compareTo(second.id);
  }
}

class CalendarEventRefreshResult {
  const CalendarEventRefreshResult({
    required this.syncedEvents,
    required this.allEvents,
  });

  final List<CalendarEvent> syncedEvents;
  final List<CalendarEvent> allEvents;
}
