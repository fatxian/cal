import 'package:flutter/foundation.dart';

import '../../../core/notifications/daily_notification_preference_service.dart';
import '../../../core/notifications/daily_notification_preferences.dart';
import '../../../core/notifications/daily_notification_service.dart';

enum NotificationPreferenceUpdateResult { saved, permissionDenied, failed }

class ProfileNotificationController extends ChangeNotifier {
  ProfileNotificationController({
    required this.preferenceService,
    required this.notificationService,
  });

  final DailyNotificationPreferenceService preferenceService;
  final DailyNotificationService notificationService;

  DailyNotificationPreferences preferences =
      DailyNotificationPreferences.defaults;
  bool isLoading = true;
  bool isUpdating = false;
  bool _isDisposed = false;

  Future<void> load() async {
    try {
      preferences = await preferenceService.load();
    } catch (error) {
      debugPrint('Could not load notification preferences: $error');
    } finally {
      isLoading = false;
      _notifyListeners();
    }
  }

  Future<NotificationPreferenceUpdateResult> save(
    DailyNotificationPreferences updatedPreferences,
  ) async {
    if (isUpdating) return NotificationPreferenceUpdateResult.failed;

    isUpdating = true;
    _notifyListeners();

    try {
      await preferenceService.save(updatedPreferences);
      preferences = updatedPreferences;
      _notifyListeners();

      final permissionGranted = await notificationService.applyPreferences(
        updatedPreferences,
      );
      return permissionGranted == false
          ? NotificationPreferenceUpdateResult.permissionDenied
          : NotificationPreferenceUpdateResult.saved;
    } catch (error) {
      debugPrint('Could not update notification preferences: $error');
      return NotificationPreferenceUpdateResult.failed;
    } finally {
      isUpdating = false;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
