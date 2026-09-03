import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'daily_notification_preferences.dart';

typedef NotificationPayloadHandler = void Function(String? payload);

class DailyNotificationService {
  DailyNotificationService({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  static const int _morningNotificationId = 1001;
  static const int _eveningNotificationId = 1002;
  static const String morningPayload = 'forecast';
  static const String eveningPayload = 'reflection';

  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'daily_reminders',
      'Daily reminders',
      channelDescription: 'Reminders to review forecasts and add reflections',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  NotificationPayloadHandler? _onNotificationTap;
  Future<void>? _initialization;

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> initializeAndSchedule({
    required DailyNotificationPreferences preferences,
    NotificationPayloadHandler? onNotificationTap,
  }) async {
    if (!_isSupportedPlatform) return;

    _onNotificationTap = onNotificationTap ?? _onNotificationTap;
    await (_initialization ??= _initialize());
    await applyPreferences(preferences);

    final launchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _onNotificationTap?.call(launchDetails?.notificationResponse?.payload);
    }
  }

  Future<void> _initialize() async {
    await _configureLocalTimeZone();
    await _notificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        _onNotificationTap?.call(response.payload);
      },
    );
  }

  Future<bool?> applyPreferences(
    DailyNotificationPreferences preferences,
  ) async {
    if (!_isSupportedPlatform) return null;

    await (_initialization ??= _initialize());
    await _notificationsPlugin.cancel(id: _morningNotificationId);
    await _notificationsPlugin.cancel(id: _eveningNotificationId);

    if (!preferences.morningEnabled && !preferences.eveningEnabled) {
      return true;
    }

    final permissionGranted = await _requestPermission();
    if (permissionGranted == false) return false;

    if (preferences.morningEnabled) {
      await _scheduleDailyReminder(
        id: _morningNotificationId,
        hour: preferences.morningHour,
        minute: preferences.morningMinute,
        body: "Review today's schedule and reveal your forecast.",
        payload: morningPayload,
      );
    }
    if (preferences.eveningEnabled) {
      await _scheduleDailyReminder(
        id: _eveningNotificationId,
        hour: preferences.eveningHour,
        minute: preferences.eveningMinute,
        body: 'How did today feel? Add your daily reflection.',
        payload: eveningPayload,
      );
    }

    return permissionGranted;
  }

  Future<void> _configureLocalTimeZone() async {
    tz_data.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));
  }

  Future<bool?> _requestPermission() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          Future<bool?>.value();
    }

    return _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        Future<bool?>.value();
  }

  Future<void> _scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String body,
    required String payload,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: 'Cal',
      body: body,
      scheduledDate: nextDailyReminderTime(
        now: tz.TZDateTime.now(tz.local),
        hour: hour,
        minute: minute,
      ),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
}

@visibleForTesting
tz.TZDateTime nextDailyReminderTime({
  required tz.TZDateTime now,
  required int hour,
  int minute = 0,
}) {
  var scheduled = tz.TZDateTime(
    now.location,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  if (!scheduled.isAfter(now)) {
    scheduled = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 1,
      hour,
      minute,
    );
  }

  return scheduled;
}
