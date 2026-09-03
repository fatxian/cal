import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/core/notifications/daily_notification_preference_service.dart';
import 'package:calendar_app/core/notifications/daily_notification_preferences.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DailyNotificationPreferenceService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = DailyNotificationPreferenceService(database: database);
  });

  tearDown(() => database.close());

  test('loads default reminders', () async {
    final preferences = await service.load();

    expect(preferences.morningEnabled, isTrue);
    expect(preferences.morningHour, 9);
    expect(preferences.morningMinute, 0);
    expect(preferences.eveningEnabled, isTrue);
    expect(preferences.eveningHour, 20);
    expect(preferences.eveningMinute, 0);
  });

  test('saves reminder settings', () async {
    const preferences = DailyNotificationPreferences(
      morningEnabled: false,
      morningHour: 8,
      morningMinute: 15,
      eveningEnabled: true,
      eveningHour: 21,
      eveningMinute: 30,
    );

    await service.save(preferences);
    final saved = await service.load();

    expect(saved.morningEnabled, isFalse);
    expect(saved.morningHour, 8);
    expect(saved.morningMinute, 15);
    expect(saved.eveningEnabled, isTrue);
    expect(saved.eveningHour, 21);
    expect(saved.eveningMinute, 30);
  });
}
