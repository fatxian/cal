class DailyCalendarFeatures {
  const DailyCalendarFeatures({
    required this.totalEventCount,
    required this.allDayEventCount,
    required this.totalScheduledMinutes,
    required this.busyMinutes,
    required this.focusMinutes,
    required this.socialMinutes,
    required this.lifeAdminMinutes,
    required this.exerciseMinutes,
    required this.restMinutes,
    required this.backToBackEventCount,
    required this.freeMinutes,
    required this.longestGapBetweenActivitiesMinutes,
    required this.maxConsecutiveBlockMinutes,
    required this.freeSlots,
  });

  final int totalEventCount;
  final int allDayEventCount;
  final int totalScheduledMinutes;
  final int busyMinutes;
  final int focusMinutes;
  final int socialMinutes;
  final int lifeAdminMinutes;
  final int exerciseMinutes;
  final int restMinutes;
  final int backToBackEventCount;
  final int freeMinutes;
  final int longestGapBetweenActivitiesMinutes;
  final int maxConsecutiveBlockMinutes;
  final List<FreeTimeSlot> freeSlots;
}

class FreeTimeSlot {
  const FreeTimeSlot({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  int get durationMinutes => endTime.difference(startTime).inMinutes;
}
