import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';

void main() {
  test('saves daily intention', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final service = DailyIntentionService(database: database);
    addTearDown(database.close);
    final day = DateTime(2026, 6, 30);
    final startTime = DateTime(2026, 6, 30, 15, 20);
    final endTime = DateTime(2026, 6, 30, 15, 30);

    await service.saveIntentionForDay(
      day,
      DailyIntention(
        factor: const ForecastFactor(
          type: ForecastFactorType.backToBackEvents,
          label: 'Back-to-back events',
        ),
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.protectBreak,
          label: 'Protect a 10-minute break at 15:20',
          startTime: startTime,
          endTime: endTime,
        ),
        calendarSnapshotKey: 'calendar-state',
      ),
    );
    final intention = await service.loadIntentionForDay(day);

    expect(intention, isNotNull);
    expect(intention!.factor.type, ForecastFactorType.backToBackEvents);
    expect(intention.factor.label, 'Back-to-back events');
    expect(intention.adjustment.type, DailyAdjustmentType.protectBreak);
    expect(intention.adjustment.label, 'Protect a 10-minute break at 15:20');
    expect(intention.adjustment.startTime, startTime);
    expect(intention.adjustment.endTime, endTime);
    expect(intention.adjustment.isActionable, isTrue);
    expect(intention.calendarSnapshotKey, 'calendar-state');
  });
}
