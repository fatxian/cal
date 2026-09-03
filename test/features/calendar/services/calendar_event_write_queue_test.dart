import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_write_queue.dart';

void main() {
  test('queues same event', () async {
    final requests = <CalendarEvent>[];
    final completions = <Completer<void>>[];
    final queue = CalendarEventWriteQueue(
      saveEvent: (event) {
        requests.add(event);
        final completion = Completer<void>();
        completions.add(completion);
        return completion.future;
      },
    );
    final event = _event('same-event');

    final firstWrite = queue.save(event);
    final secondWrite = queue.save(event.copyWith(title: 'Updated'));
    await Future<void>.delayed(Duration.zero);

    expect(requests, hasLength(1));

    completions.first.complete();
    await firstWrite;
    await Future<void>.delayed(Duration.zero);

    expect(requests, hasLength(2));
    completions.last.complete();
    await secondWrite;
  });

  test('allows different events', () async {
    final requests = <CalendarEvent>[];
    final completions = <Completer<void>>[];
    final queue = CalendarEventWriteQueue(
      saveEvent: (event) {
        requests.add(event);
        final completion = Completer<void>();
        completions.add(completion);
        return completion.future;
      },
    );

    final firstWrite = queue.save(_event('first'));
    final secondWrite = queue.save(_event('second'));
    await Future<void>.delayed(Duration.zero);

    expect(requests, hasLength(2));
    for (final completion in completions) {
      completion.complete();
    }
    await Future.wait([firstWrite, secondWrite]);
  });
}

CalendarEvent _event(String id) {
  return CalendarEvent(
    id: id,
    externalId: id,
    source: CalendarEventSource.google,
    title: id,
    startTime: DateTime(2026, 8, 2, 9),
    endTime: DateTime(2026, 8, 2, 10),
  );
}
