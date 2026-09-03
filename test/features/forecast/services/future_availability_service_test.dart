import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/forecast/services/future_availability_service.dart';

void main() {
  const service = FutureAvailabilityService();
  final day = DateTime(2026, 7, 20);

  CalendarEvent event(
    String id,
    int startHour,
    int endHour, {
    CalendarEventCategory? category,
  }) {
    return CalendarEvent(
      id: id,
      title: id,
      startTime: DateTime(2026, 7, 20, startHour),
      endTime: DateTime(2026, 7, 20, endHour),
      category: category,
    );
  }

  test('finds remaining free time', () {
    final events = [
      event('class', 9, 10),
      event('meeting', 13, 14),
      event('dinner', 18, 19),
    ];

    final slots = service.availableSlots(
      day: day,
      events: events,
      now: DateTime(2026, 7, 20, 16),
    );

    expect(slots.map((slot) => [slot.startTime.hour, slot.endTime.hour]), [
      [16, 18],
      [19, 22],
    ]);
  });

  test('finds future gaps', () {
    final gaps = service.gapsBetweenActivities(
      day: day,
      events: [
        event('class', 9, 10),
        event('meeting', 13, 14),
        event('dinner', 18, 19),
      ],
      now: DateTime(2026, 7, 20, 16),
    );

    expect(gaps, hasLength(1));
    expect(gaps.single.startTime, DateTime(2026, 7, 20, 16));
    expect(gaps.single.endTime, DateTime(2026, 7, 20, 18));
  });

  test('reserves planned rest', () {
    final slots = service.availableSlots(
      day: day,
      events: [event('rest', 16, 17, category: CalendarEventCategory.rest)],
      now: DateTime(2026, 7, 20, 15),
    );

    expect(slots.first.startTime, DateTime(2026, 7, 20, 15));
    expect(slots.first.endTime, DateTime(2026, 7, 20, 16));
    expect(slots.last.startTime, DateTime(2026, 7, 20, 17));
  });

  test('checks required duration', () {
    final slots = [
      FutureAvailabilitySlot(
        startTime: DateTime(2026, 7, 20, 16),
        endTime: DateTime(2026, 7, 20, 16, 10),
      ),
    ];

    expect(service.firstSlotWithDuration(slots, 5), isNotNull);
    expect(service.firstSlotWithDuration(slots, 10), isNotNull);
    expect(service.firstSlotWithDuration(slots, 15), isNull);
  });

  test('handles late request', () {
    final now = DateTime(2026, 7, 20, 22, 1);

    expect(
      service.availableSlots(day: day, events: const [], now: now),
      isEmpty,
    );
    expect(
      service.gapsBetweenActivities(day: day, events: const [], now: now),
      isEmpty,
    );
  });

  test('handles full schedule', () {
    final slots = service.availableSlots(
      day: day,
      events: [event('remaining-day', 16, 22)],
      now: DateTime(2026, 7, 20, 16),
    );

    expect(slots, isEmpty);
  });
}
