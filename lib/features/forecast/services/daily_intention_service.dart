import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/daily_intention.dart';

class DailyIntentionService {
  const DailyIntentionService({required this.database});

  final AppDatabase database;

  Future<DailyIntention?> loadIntentionForDay(DateTime day) async {
    final row = await (database.select(
      database.dailyIntentionItems,
    )..where((table) => table.date.equals(dateKey(day)))).getSingleOrNull();

    if (row == null) return null;

    return DailyIntention(
      factor: ForecastFactor(
        type: _decodeFactorType(row.factorType),
        label: row.selectedFactor,
      ),
      adjustment: DailyAdjustment(
        type: _decodeAdjustmentType(row.adjustmentType, row.selectedAdjustment),
        label: row.selectedAdjustment,
        startTime: row.adjustmentStartTime,
        endTime: row.adjustmentEndTime,
      ),
      calendarSnapshotKey: row.calendarSnapshotKey,
    );
  }

  Future<void> saveIntentionForDay(
    DateTime day,
    DailyIntention intention,
  ) async {
    final date = dateKey(day);
    // preserve the original creation time when an intention is edited
    final existingRow = await (database.select(
      database.dailyIntentionItems,
    )..where((table) => table.date.equals(date))).getSingleOrNull();

    await database
        .into(database.dailyIntentionItems)
        .insert(
          DailyIntentionItemsCompanion.insert(
            date: date,
            selectedFactor: intention.factor.label,
            factorType: Value(intention.factor.type.name),
            selectedAdjustment: intention.adjustment.label,
            adjustmentType: Value(intention.adjustment.type.name),
            adjustmentStartTime: Value(intention.adjustment.startTime),
            adjustmentEndTime: Value(intention.adjustment.endTime),
            calendarSnapshotKey: Value(intention.calendarSnapshotKey),
            createdAt: Value(existingRow?.createdAt ?? DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  ForecastFactorType _decodeFactorType(String value) {
    return ForecastFactorType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ForecastFactorType.unspecified,
    );
  }

  DailyAdjustmentType _decodeAdjustmentType(String value, String label) {
    // map legacy data or default fallback
    if (value == DailyAdjustmentType.unspecified.name &&
        label == 'No change today') {
      return DailyAdjustmentType.noChange;
    }

    return DailyAdjustmentType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => DailyAdjustmentType.unspecified,
    );
  }
}
