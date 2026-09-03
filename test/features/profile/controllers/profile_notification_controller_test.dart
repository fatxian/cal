import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/core/notifications/daily_notification_preference_service.dart';
import 'package:calendar_app/core/notifications/daily_notification_preferences.dart';
import 'package:calendar_app/core/notifications/daily_notification_service.dart';
import 'package:calendar_app/features/profile/controllers/profile_notification_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DailyNotificationPreferenceService preferenceService;
  late _FakeNotificationService notificationService;
  late ProfileNotificationController controller;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    preferenceService = DailyNotificationPreferenceService(database: database);
    notificationService = _FakeNotificationService();
    controller = ProfileNotificationController(
      preferenceService: preferenceService,
      notificationService: notificationService,
    );
  });

  tearDown(() async {
    controller.dispose();
    await database.close();
  });

  test('loads notification settings', () async {
    const saved = DailyNotificationPreferences(
      morningEnabled: false,
      morningHour: 8,
      morningMinute: 30,
      eveningEnabled: true,
      eveningHour: 21,
      eveningMinute: 15,
    );
    await preferenceService.save(saved);

    await controller.load();

    expect(controller.isLoading, isFalse);
    expect(controller.preferences.morningEnabled, isFalse);
    expect(controller.preferences.morningHour, 8);
    expect(controller.preferences.eveningMinute, 15);
  });

  test('saves notification settings', () async {
    const updated = DailyNotificationPreferences(
      morningEnabled: true,
      morningHour: 7,
      morningMinute: 45,
      eveningEnabled: false,
      eveningHour: 20,
      eveningMinute: 0,
    );

    final result = await controller.save(updated);

    expect(result, NotificationPreferenceUpdateResult.saved);
    expect(controller.preferences.morningHour, 7);
    expect(notificationService.appliedPreferences, same(updated));
    expect((await preferenceService.load()).eveningEnabled, isFalse);
    expect(controller.isUpdating, isFalse);
  });

  test('handles denied permission', () async {
    notificationService.result = false;

    final result = await controller.save(DailyNotificationPreferences.defaults);

    expect(result, NotificationPreferenceUpdateResult.permissionDenied);
    expect(controller.isUpdating, isFalse);
  });

  test('handles scheduling failure', () async {
    notificationService.error = StateError('schedule failed');

    final result = await controller.save(DailyNotificationPreferences.defaults);

    expect(result, NotificationPreferenceUpdateResult.failed);
    expect(controller.isUpdating, isFalse);
  });
}

class _FakeNotificationService extends DailyNotificationService {
  bool? result = true;
  Object? error;
  DailyNotificationPreferences? appliedPreferences;

  @override
  Future<bool?> applyPreferences(
    DailyNotificationPreferences preferences,
  ) async {
    final schedulingError = error;
    if (schedulingError != null) throw schedulingError;
    appliedPreferences = preferences;
    return result;
  }
}
