enum DailyAdjustmentType {
  protectBreak,
  keepTimeFree,
  shortWalk,
  stretch,
  screenBreak,
  focusSession,
  socialMoment,
  lifeAdminTask,
  leaveBuffer,
  quietPause,
  keepPlan,
  noticeEnergy,
  noChange,
  unspecified,
}

class DailyAdjustment {
  const DailyAdjustment({
    required this.type,
    required this.label,
    this.startTime,
    this.endTime,
  });

  final DailyAdjustmentType type;
  final String label;
  final DateTime? startTime;
  final DateTime? endTime;

  bool get isActionable => type != DailyAdjustmentType.noChange;
}

enum ForecastFactorType {
  scheduledTime,
  backToBackEvents,
  longestGapBetweenActivities,
  longestScheduledBlock,
  focusTime,
  socialTime,
  lifeAdminTasks,
  exercise,
  outsideCalendar,
  nothingStandsOut,
  notSure,
  unspecified,
}

class ForecastFactor {
  const ForecastFactor({required this.type, required this.label});

  final ForecastFactorType type;
  final String label;
}

class DailyIntention {
  const DailyIntention({
    required this.factor,
    required this.adjustment,
    required this.calendarSnapshotKey,
  });

  final ForecastFactor factor;
  final DailyAdjustment adjustment;
  final String calendarSnapshotKey;
}
