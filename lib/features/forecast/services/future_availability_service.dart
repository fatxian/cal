import '../../calendar/models/calendar_event.dart';

class FutureAvailabilitySlot {
  const FutureAvailabilitySlot({
    required this.startTime,
    required this.endTime,
  });

  final DateTime startTime;
  final DateTime endTime;

  int get durationMinutes => endTime.difference(startTime).inMinutes;
}

class FutureAvailabilityService {
  const FutureAvailabilityService({
    this.analysisStartHour = 8,
    this.analysisEndHour = 22,
  });

  final int analysisStartHour;
  final int analysisEndHour;

  List<FutureAvailabilitySlot> availableSlots({
    required DateTime day,
    required List<CalendarEvent> events,
    required DateTime now,
  }) {
    final bounds = _bounds(day, now);
    if (bounds == null) return const [];

    final occupiedRanges = _occupiedRanges(
      events: events,
      windowStart: bounds.start,
      windowEnd: bounds.end,
    );

    return _freeSlots(
      occupiedRanges: occupiedRanges,
      windowStart: bounds.start,
      windowEnd: bounds.end,
    );
  }

  List<FutureAvailabilitySlot> gapsBetweenActivities({
    required DateTime day,
    required List<CalendarEvent> events,
    required DateTime now,
  }) {
    final bounds = _bounds(day, now);
    if (bounds == null) return const [];

    final dayStart = DateTime(day.year, day.month, day.day, analysisStartHour);
    final occupiedRanges = _occupiedRanges(
      events: events,
      windowStart: dayStart,
      windowEnd: bounds.end,
    );
    if (occupiedRanges.length < 2) return const [];

    final slots = <FutureAvailabilitySlot>[];
    for (var index = 0; index < occupiedRanges.length - 1; index++) {
      final start = occupiedRanges[index].endTime.isAfter(bounds.start)
          ? occupiedRanges[index].endTime
          : bounds.start;
      final end = occupiedRanges[index + 1].startTime;
      if (end.isAfter(start)) {
        slots.add(FutureAvailabilitySlot(startTime: start, endTime: end));
      }
    }

    return slots;
  }

  FutureAvailabilitySlot? firstSlotWithDuration(
    List<FutureAvailabilitySlot> slots,
    int minimumMinutes,
  ) {
    for (final slot in slots) {
      if (slot.durationMinutes >= minimumMinutes) return slot;
    }

    return null;
  }

  _AvailabilityBounds? _bounds(DateTime day, DateTime now) {
    final dayStart = DateTime(day.year, day.month, day.day, analysisStartHour);
    final dayEnd = DateTime(day.year, day.month, day.day, analysisEndHour);
    final roundedNow = _roundUpToNextTenMinutes(now);
    final start = _isSameDay(day, now) && roundedNow.isAfter(dayStart)
        ? roundedNow
        : dayStart;

    if (!dayEnd.isAfter(start)) return null;
    return _AvailabilityBounds(start, dayEnd);
  }

  List<_OccupiedRange> _occupiedRanges({
    required List<CalendarEvent> events,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) {
    final ranges =
        events
            .where(
              (event) =>
                  !event.isAllDay &&
                  event.endTime.isAfter(event.startTime) &&
                  event.endTime.isAfter(windowStart) &&
                  event.startTime.isBefore(windowEnd),
            )
            .map(
              (event) => _OccupiedRange(
                event.startTime.isBefore(windowStart)
                    ? windowStart
                    : event.startTime,
                event.endTime.isAfter(windowEnd) ? windowEnd : event.endTime,
              ),
            )
            .toList()
          ..sort(
            (first, second) => first.startTime.compareTo(second.startTime),
          );
    if (ranges.isEmpty) return const [];

    final merged = <_OccupiedRange>[];
    var currentStart = ranges.first.startTime;
    var currentEnd = ranges.first.endTime;
    for (final range in ranges.skip(1)) {
      if (range.startTime.isAfter(currentEnd)) {
        merged.add(_OccupiedRange(currentStart, currentEnd));
        currentStart = range.startTime;
        currentEnd = range.endTime;
      } else if (range.endTime.isAfter(currentEnd)) {
        currentEnd = range.endTime;
      }
    }
    merged.add(_OccupiedRange(currentStart, currentEnd));

    return merged;
  }

  List<FutureAvailabilitySlot> _freeSlots({
    required List<_OccupiedRange> occupiedRanges,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) {
    final slots = <FutureAvailabilitySlot>[];
    var slotStart = windowStart;

    for (final range in occupiedRanges) {
      if (range.startTime.isAfter(slotStart)) {
        slots.add(
          FutureAvailabilitySlot(
            startTime: slotStart,
            endTime: range.startTime,
          ),
        );
      }
      if (range.endTime.isAfter(slotStart)) slotStart = range.endTime;
    }

    if (windowEnd.isAfter(slotStart)) {
      slots.add(
        FutureAvailabilitySlot(startTime: slotStart, endTime: windowEnd),
      );
    }

    return slots;
  }

  DateTime _roundUpToNextTenMinutes(DateTime time) {
    final base = DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
    );
    final remainder = base.minute % 10;
    final hasPartialMinute =
        time.second != 0 || time.millisecond != 0 || time.microsecond != 0;
    if (remainder == 0 && !hasPartialMinute) return base;

    return base.add(Duration(minutes: remainder == 0 ? 10 : 10 - remainder));
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _AvailabilityBounds {
  const _AvailabilityBounds(this.start, this.end);

  final DateTime start;
  final DateTime end;
}

class _OccupiedRange {
  const _OccupiedRange(this.startTime, this.endTime);

  final DateTime startTime;
  final DateTime endTime;
}
