import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/calendar_event.dart';
import '../models/calendar_sync_status.dart';

class CalendarSyncService {
  const CalendarSyncService({required this.database});

  final AppDatabase database;

  Future<void> saveSuccessfulSync({
    required DateTime day,
    required CalendarEventSource source,
    required DateTime syncedAt,
    required int eventCount,
  }) async {
    await database
        .into(database.calendarSyncItems)
        .insert(
          CalendarSyncItemsCompanion.insert(
            date: dateKey(day),
            source: source.name,
            lastSuccessfulSyncAt: syncedAt,
            eventCount: eventCount,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<CalendarSyncStatus?> loadLatestSuccessfulSyncForDay(
    DateTime day,
  ) async {
    final row =
        await (database.select(database.calendarSyncItems)
              ..where((table) => table.date.equals(dateKey(day)))
              ..orderBy([
                (table) => OrderingTerm.desc(table.lastSuccessfulSyncAt),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (row == null) return null;

    return CalendarSyncStatus(
      day: DateTime.parse(row.date),
      source: _decodeSource(row.source),
      lastSuccessfulSyncAt: row.lastSuccessfulSyncAt,
      eventCount: row.eventCount,
    );
  }

  CalendarEventSource _decodeSource(String source) {
    return CalendarEventSource.values.firstWhere(
      (value) => value.name == source,
      orElse: () => CalendarEventSource.manual,
    );
  }
}
