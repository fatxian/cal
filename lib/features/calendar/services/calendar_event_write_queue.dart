import '../models/calendar_event.dart';

class CalendarEventWriteQueue {
  CalendarEventWriteQueue({required this.saveEvent});

  final Future<void> Function(CalendarEvent event) saveEvent;
  final Map<String, Future<void>> _pendingWrites = {};

  Future<void> save(CalendarEvent event) {
    final eventKey = identityKey(event);
    final previousWrite = _pendingWrites[eventKey] ?? Future<void>.value();
    final pendingWrite = previousWrite.then(
      (_) => saveEvent(event),
      onError: (_) => saveEvent(event),
    );
    _pendingWrites[eventKey] = pendingWrite;

    return pendingWrite.whenComplete(() {
      if (identical(_pendingWrites[eventKey], pendingWrite)) {
        _pendingWrites.remove(eventKey);
      }
    });
  }

  String identityKey(CalendarEvent event) {
    return '${event.source.name}:${event.externalId ?? event.id}';
  }
}
