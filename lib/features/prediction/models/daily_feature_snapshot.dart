import 'daily_calendar_features.dart';

class DailyFeatureSnapshot {
  const DailyFeatureSnapshot({
    required this.id,
    required this.day,
    required this.capturedAt,
    required this.analysisStartHour,
    required this.analysisEndHour,
    required this.predictionPhase,
    required this.calculationVersion,
    required this.calendarSnapshotKey,
    required this.features,
  });

  final int id;
  final DateTime day;
  final DateTime capturedAt;
  final int analysisStartHour;
  final int analysisEndHour;
  final String predictionPhase;
  final int calculationVersion;
  final String calendarSnapshotKey;
  final DailyCalendarFeatures features;
}
