import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/services/calendar_sync_service.dart';

void main() {
  test('records empty sync', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final service = CalendarSyncService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 28);
    final firstSync = DateTime(2026, 6, 28, 9);
    final latestSync = DateTime(2026, 6, 28, 12);

    await service.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: firstSync,
      eventCount: 0,
    );
    await service.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: latestSync,
      eventCount: 0,
    );
    final status = await service.loadLatestSuccessfulSyncForDay(day);

    expect(status, isNotNull);
    expect(status!.source, CalendarEventSource.google);
    expect(status.lastSuccessfulSyncAt, latestSync);
    expect(status.eventCount, 0);
  });
}
