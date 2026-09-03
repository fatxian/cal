import 'package:flutter/foundation.dart';

@immutable
class DailyNotificationPreferences {
  const DailyNotificationPreferences({
    required this.morningEnabled,
    required this.morningHour,
    required this.morningMinute,
    required this.eveningEnabled,
    required this.eveningHour,
    required this.eveningMinute,
  }) : assert(morningHour >= 0 && morningHour <= 23),
       assert(morningMinute >= 0 && morningMinute <= 59),
       assert(eveningHour >= 0 && eveningHour <= 23),
       assert(eveningMinute >= 0 && eveningMinute <= 59);

  static const defaults = DailyNotificationPreferences(
    morningEnabled: true,
    morningHour: 9,
    morningMinute: 0,
    eveningEnabled: true,
    eveningHour: 20,
    eveningMinute: 0,
  );

  final bool morningEnabled;
  final int morningHour;
  final int morningMinute;
  final bool eveningEnabled;
  final int eveningHour;
  final int eveningMinute;

  DailyNotificationPreferences copyWith({
    bool? morningEnabled,
    int? morningHour,
    int? morningMinute,
    bool? eveningEnabled,
    int? eveningHour,
    int? eveningMinute,
  }) {
    return DailyNotificationPreferences(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
    );
  }
}
