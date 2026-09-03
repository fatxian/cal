import '../../calendar/models/calendar_event.dart';
import '../../calendar/models/calendar_event_category.dart';
import '../models/daily_calendar_features.dart';

class DailyFeatureCalculator {
  // limit calendar features to waking hours so sleep is not counted as free time
  const DailyFeatureCalculator({
    this.analysisStartHour = 8,
    this.analysisEndHour = 22,
  }) : assert(analysisStartHour >= 0),
       assert(analysisEndHour <= 24),
       assert(analysisStartHour < analysisEndHour);

  final int analysisStartHour;
  final int analysisEndHour;

  DailyCalendarFeatures calculate({
    required DateTime day,
    required List<CalendarEvent> events,
  }) {
    final analysisStart = DateTime(
      day.year,
      day.month,
      day.day,
      analysisStartHour,
    );
    final analysisEnd = DateTime(day.year, day.month, day.day, analysisEndHour);
    // keep timed events in the analysis window, clip them to fit the window
    // and sort them by time
    final timedEvents =
        events
            .where(
              (event) =>
                  _isWithinAnalysisWindow(event, analysisStart, analysisEnd),
            )
            .map((event) => _ClippedEvent(event, analysisStart, analysisEnd))
            .toList()
          ..sort(
            (first, second) => first.startTime.compareTo(second.startTime),
          );
    // use non-Rest events for busy time and consecutive busy blocks
    // all timed events are still used when calculating schedule gaps
    final busyEvents = timedEvents
        .where((event) => event.event.category != CalendarEventCategory.rest)
        .toList();
    // merge overlapping intervals before summing durations
    // to avoid counting the same time more than once
    final occupiedRanges = _occupiedRanges(timedEvents);
    final busyRanges = _occupiedRanges(busyEvents);
    final freeSlots = _freeSlots(busyRanges, analysisStart, analysisEnd);
    final gapsBetweenActivities = _gapsBetweenRanges(occupiedRanges);

    return DailyCalendarFeatures(
      totalEventCount: timedEvents.length,
      allDayEventCount: events.where((event) => event.isAllDay).length,
      totalScheduledMinutes: _rangeMinutes(occupiedRanges),
      busyMinutes: _rangeMinutes(busyRanges),
      focusMinutes: _categoryMinutes(timedEvents, CalendarEventCategory.focus),
      socialMinutes: _categoryMinutes(
        timedEvents,
        CalendarEventCategory.social,
      ),
      lifeAdminMinutes: _categoryMinutes(
        timedEvents,
        CalendarEventCategory.lifeAdmin,
      ),
      exerciseMinutes: _categoryMinutes(
        timedEvents,
        CalendarEventCategory.exercise,
      ),
      restMinutes: _categoryMinutes(timedEvents, CalendarEventCategory.rest),
      backToBackEventCount: _backToBackEventCount(busyEvents),
      freeMinutes: freeSlots.fold(
        0,
        (total, slot) => total + slot.durationMinutes,
      ),
      longestGapBetweenActivitiesMinutes: gapsBetweenActivities.fold(
        0,
        (longest, slot) =>
            slot.durationMinutes > longest ? slot.durationMinutes : longest,
      ),
      maxConsecutiveBlockMinutes: _maxConsecutiveBlockMinutes(busyEvents),
      freeSlots: freeSlots,
    );
  }

  bool _isWithinAnalysisWindow(
    CalendarEvent event,
    DateTime analysisStart,
    DateTime analysisEnd,
  ) {
    return !event.isAllDay &&
        event.endTime.isAfter(event.startTime) &&
        event.endTime.isAfter(analysisStart) &&
        event.startTime.isBefore(analysisEnd);
  }

  int _categoryMinutes(
    List<_ClippedEvent> events,
    CalendarEventCategory category,
  ) {
    final categoryEvents = events
        .where((event) => event.event.category == category)
        .toList();

    return _rangeMinutes(_occupiedRanges(categoryEvents));
  }

  // count events with a gap of 15 minutes or less as back-to-back
  int _backToBackEventCount(List<_ClippedEvent> events) {
    var count = 0;

    for (var index = 0; index < events.length - 1; index++) {
      final gap = events[index + 1].startTime.difference(events[index].endTime);
      if (gap.inMinutes <= 15) {
        count++;
      }
    }

    return count;
  }

  // calculate the longest duration of consecutive events with gaps of <= 15 minutes
  int _maxConsecutiveBlockMinutes(List<_ClippedEvent> events) {
    if (events.isEmpty) return 0;

    var longestBlockMinutes = 0;
    var blockStart = events.first.startTime;
    var blockEnd = events.first.endTime;

    for (final event in events.skip(1)) {
      final gap = event.startTime.difference(blockEnd);
      if (gap.inMinutes <= 15) {
        if (event.endTime.isAfter(blockEnd)) {
          blockEnd = event.endTime;
        }
        continue;
      }

      longestBlockMinutes = _longerDuration(
        longestBlockMinutes,
        blockEnd.difference(blockStart).inMinutes,
      );
      blockStart = event.startTime;
      blockEnd = event.endTime;
    }

    return _longerDuration(
      longestBlockMinutes,
      blockEnd.difference(blockStart).inMinutes,
    );
  }

  int _longerDuration(int first, int second) => first > second ? first : second;

  // merge overlapping events to avoid counting busy time many times
  List<_TimeRange> _occupiedRanges(List<_ClippedEvent> events) {
    if (events.isEmpty) return [];

    final ranges = <_TimeRange>[];
    var currentStart = events.first.startTime;
    var currentEnd = events.first.endTime;

    for (final event in events.skip(1)) {
      if (event.startTime.isAfter(currentEnd)) {
        ranges.add(_TimeRange(currentStart, currentEnd));
        currentStart = event.startTime;
        currentEnd = event.endTime;
      } else if (event.endTime.isAfter(currentEnd)) {
        currentEnd = event.endTime;
      }
    }

    ranges.add(_TimeRange(currentStart, currentEnd));
    return ranges;
  }

  List<FreeTimeSlot> _freeSlots(
    List<_TimeRange> occupiedRanges,
    DateTime analysisStart,
    DateTime analysisEnd,
  ) {
    final slots = <FreeTimeSlot>[];
    var slotStart = analysisStart;

    for (final range in occupiedRanges) {
      if (range.startTime.isAfter(slotStart)) {
        slots.add(FreeTimeSlot(startTime: slotStart, endTime: range.startTime));
      }
      slotStart = range.endTime;
    }

    if (analysisEnd.isAfter(slotStart)) {
      slots.add(FreeTimeSlot(startTime: slotStart, endTime: analysisEnd));
    }

    return slots;
  }

  List<FreeTimeSlot> _gapsBetweenRanges(List<_TimeRange> occupiedRanges) {
    if (occupiedRanges.length < 2) return [];

    return [
      for (var index = 0; index < occupiedRanges.length - 1; index++)
        FreeTimeSlot(
          startTime: occupiedRanges[index].endTime,
          endTime: occupiedRanges[index + 1].startTime,
        ),
    ];
  }

  int _rangeMinutes(List<_TimeRange> ranges) {
    return ranges.fold(
      0,
      (total, range) =>
          total + range.endTime.difference(range.startTime).inMinutes,
    );
  }
}

// clip event times to fit within the active analysis window
class _ClippedEvent {
  _ClippedEvent(this.event, DateTime analysisStart, DateTime analysisEnd)
    : startTime = event.startTime.isBefore(analysisStart)
          ? analysisStart
          : event.startTime,
      endTime = event.endTime.isAfter(analysisEnd)
          ? analysisEnd
          : event.endTime;

  final CalendarEvent event;
  final DateTime startTime;
  final DateTime endTime;

  Duration get duration => endTime.difference(startTime);
}

class _TimeRange {
  const _TimeRange(this.startTime, this.endTime);

  final DateTime startTime;
  final DateTime endTime;
}
