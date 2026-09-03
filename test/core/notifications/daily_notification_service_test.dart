import 'package:calendar_app/core/notifications/daily_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('nextDailyReminderTime', () {
    final location = tz.UTC;

    test('uses today', () {
      final result = nextDailyReminderTime(
        now: tz.TZDateTime(location, 2026, 7, 21, 8, 30),
        hour: 9,
      );

      expect(result, tz.TZDateTime(location, 2026, 7, 21, 9));
    });

    test('uses tomorrow', () {
      final result = nextDailyReminderTime(
        now: tz.TZDateTime(location, 2026, 7, 21, 20, 30),
        hour: 20,
      );

      expect(result, tz.TZDateTime(location, 2026, 7, 22, 20));
    });

    test('handles exact time', () {
      final result = nextDailyReminderTime(
        now: tz.TZDateTime(location, 2026, 7, 21, 9),
        hour: 9,
      );

      expect(result, tz.TZDateTime(location, 2026, 7, 22, 9));
    });

    test('keeps reminder minute', () {
      final result = nextDailyReminderTime(
        now: tz.TZDateTime(location, 2026, 7, 21, 8),
        hour: 9,
        minute: 45,
      );

      expect(result, tz.TZDateTime(location, 2026, 7, 21, 9, 45));
    });
  });
}
