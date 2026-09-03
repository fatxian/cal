import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_calculator.dart';

void main() {
  const calculator = DailyFeatureCalculator();
  final day = DateTime(2026, 6, 26);

  CalendarEvent event({
    required String id,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    CalendarEventCategory? category,
    bool isAllDay = false,
  }) {
    return CalendarEvent(
      id: id,
      title: id,
      startTime: DateTime(day.year, day.month, day.day, startHour, startMinute),
      endTime: DateTime(day.year, day.month, day.day, endHour, endMinute),
      category: category,
      isAllDay: isAllDay,
    );
  }

  test('calculates daily features', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'work',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 0,
          category: CalendarEventCategory.focus,
        ),
        event(
          id: 'study',
          startHour: 10,
          startMinute: 10,
          endHour: 11,
          endMinute: 40,
          category: CalendarEventCategory.focus,
        ),
        event(
          id: 'lunch',
          startHour: 12,
          startMinute: 0,
          endHour: 13,
          endMinute: 0,
          category: CalendarEventCategory.social,
        ),
        event(
          id: 'walk',
          startHour: 13,
          startMinute: 0,
          endHour: 13,
          endMinute: 30,
          category: CalendarEventCategory.exercise,
        ),
      ],
    );

    expect(features.totalEventCount, 4);
    expect(features.allDayEventCount, 0);
    expect(features.totalScheduledMinutes, 240);
    expect(features.busyMinutes, 240);
    expect(features.focusMinutes, 150);
    expect(features.socialMinutes, 60);
    expect(features.lifeAdminMinutes, 0);
    expect(features.exerciseMinutes, 30);
    expect(features.restMinutes, 0);
    expect(features.backToBackEventCount, 2);
    expect(features.freeMinutes, 600);
    expect(features.longestGapBetweenActivitiesMinutes, 20);
    expect(features.maxConsecutiveBlockMinutes, 160);
    expect(features.freeSlots.map((slot) => slot.durationMinutes), [
      60,
      10,
      20,
      510,
    ]);
  });

  test('handles empty calendar', () {
    final features = calculator.calculate(day: day, events: []);

    expect(features.totalEventCount, 0);
    expect(features.totalScheduledMinutes, 0);
    expect(features.busyMinutes, 0);
    expect(features.freeMinutes, 840);
    expect(features.longestGapBetweenActivitiesMinutes, 0);
    expect(features.maxConsecutiveBlockMinutes, 0);
    expect(features.freeSlots.single.startTime, DateTime(2026, 6, 26, 8));
    expect(features.freeSlots.single.endTime, DateTime(2026, 6, 26, 22));
  });

  test('handles one activity', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'only-event',
          startHour: 13,
          startMinute: 0,
          endHour: 14,
          endMinute: 0,
        ),
      ],
    );

    expect(features.longestGapBetweenActivitiesMinutes, 0);
  });

  test('counts 15-minute gap', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'first',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 0,
        ),
        event(
          id: 'second',
          startHour: 10,
          startMinute: 15,
          endHour: 11,
          endMinute: 0,
        ),
      ],
    );

    expect(features.backToBackEventCount, 1);
    expect(features.maxConsecutiveBlockMinutes, 120);
    expect(features.longestGapBetweenActivitiesMinutes, 15);
    expect(features.freeSlots.map((slot) => slot.durationMinutes), [
      60,
      15,
      660,
    ]);
  });

  test('ignores 16-minute gap', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'first',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 0,
        ),
        event(
          id: 'second',
          startHour: 10,
          startMinute: 16,
          endHour: 11,
          endMinute: 16,
        ),
      ],
    );

    expect(features.backToBackEventCount, 0);
    expect(features.maxConsecutiveBlockMinutes, 60);
  });

  test('merges overlapping activities', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'first',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 0,
        ),
        event(
          id: 'second',
          startHour: 9,
          startMinute: 30,
          endHour: 10,
          endMinute: 30,
        ),
      ],
    );

    expect(features.totalScheduledMinutes, 90);
    expect(features.busyMinutes, 90);
    expect(features.freeMinutes, 750);
    expect(features.backToBackEventCount, 1);
    expect(features.maxConsecutiveBlockMinutes, 90);
    expect(features.longestGapBetweenActivitiesMinutes, 0);
  });

  test('clips activity times', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'early',
          startHour: 7,
          startMinute: 0,
          endHour: 9,
          endMinute: 0,
          category: CalendarEventCategory.focus,
        ),
        event(
          id: 'late',
          startHour: 21,
          startMinute: 0,
          endHour: 23,
          endMinute: 0,
          category: CalendarEventCategory.focus,
        ),
      ],
    );

    expect(features.totalEventCount, 2);
    expect(features.totalScheduledMinutes, 120);
    expect(features.busyMinutes, 120);
    expect(features.focusMinutes, 120);
    expect(features.freeMinutes, 720);
    expect(features.longestGapBetweenActivitiesMinutes, 720);
  });

  test('counts all-day activities', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'all-day',
          startHour: 0,
          startMinute: 0,
          endHour: 0,
          endMinute: 0,
          isAllDay: true,
        ),
      ],
    );

    expect(features.totalEventCount, 0);
    expect(features.allDayEventCount, 1);
    expect(features.totalScheduledMinutes, 0);
    expect(features.busyMinutes, 0);
    expect(features.freeMinutes, 840);
    expect(features.longestGapBetweenActivitiesMinutes, 0);
  });

  test('excludes planned rest', () {
    final features = calculator.calculate(
      day: day,
      events: [
        event(
          id: 'focus-before',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 0,
          category: CalendarEventCategory.focus,
        ),
        event(
          id: 'rest',
          startHour: 10,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          category: CalendarEventCategory.rest,
        ),
        event(
          id: 'focus-after',
          startHour: 10,
          startMinute: 30,
          endHour: 11,
          endMinute: 30,
          category: CalendarEventCategory.focus,
        ),
      ],
    );

    expect(features.totalScheduledMinutes, 150);
    expect(features.busyMinutes, 120);
    expect(features.focusMinutes, 120);
    expect(features.restMinutes, 30);
    expect(features.backToBackEventCount, 0);
    expect(features.maxConsecutiveBlockMinutes, 60);
    expect(features.freeMinutes, 720);
    expect(features.longestGapBetweenActivitiesMinutes, 0);
  });
}
