import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'daily_notification_preferences.dart';

class DailyNotificationPreferenceService {
  const DailyNotificationPreferenceService({required this.database});

  static const int preferenceRowId = 1;

  final AppDatabase database;

  Future<DailyNotificationPreferences> load() async {
    final row = await (database.select(
      database.notificationPreferenceItems,
    )..where((table) => table.id.equals(preferenceRowId))).getSingleOrNull();

    if (row == null) return DailyNotificationPreferences.defaults;

    return DailyNotificationPreferences(
      morningEnabled: row.morningEnabled,
      morningHour: row.morningHour,
      morningMinute: row.morningMinute,
      eveningEnabled: row.eveningEnabled,
      eveningHour: row.eveningHour,
      eveningMinute: row.eveningMinute,
    );
  }

  Future<void> save(DailyNotificationPreferences preferences) async {
    await database
        .into(database.notificationPreferenceItems)
        .insert(
          NotificationPreferenceItemsCompanion.insert(
            id: const Value(preferenceRowId),
            morningEnabled: Value(preferences.morningEnabled),
            morningHour: Value(preferences.morningHour),
            morningMinute: Value(preferences.morningMinute),
            eveningEnabled: Value(preferences.eveningEnabled),
            eveningHour: Value(preferences.eveningHour),
            eveningMinute: Value(preferences.eveningMinute),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
