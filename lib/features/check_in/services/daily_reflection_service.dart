import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/daily_reflection.dart';

class DailyReflectionService {
  const DailyReflectionService({required this.database});

  final AppDatabase database;

  Future<DailyReflection?> loadReflectionForDay(DateTime day) async {
    final date = dateKey(day);
    final row = await (database.select(
      database.dailyReflectionItems,
    )..where((table) => table.date.equals(date))).getSingleOrNull();

    if (row == null) return null;

    return DailyReflection(
      energyScore: row.energyScore,
      intentionCompletionScore: row.intentionCompletionScore,
      intentionHelpfulnessScore: row.intentionHelpfulnessScore,
    );
  }

  Future<void> saveReflectionForDay(
    DateTime day,
    DailyReflection reflection,
  ) async {
    final date = dateKey(day);
    // preserve the original creation time when a reflection is edited
    final existingRow = await (database.select(
      database.dailyReflectionItems,
    )..where((table) => table.date.equals(date))).getSingleOrNull();

    await database
        .into(database.dailyReflectionItems)
        .insert(
          DailyReflectionItemsCompanion.insert(
            date: date,
            energyScore: reflection.energyScore,
            intentionCompletionScore: Value(
              reflection.intentionCompletionScore,
            ),
            intentionHelpfulnessScore: Value(
              reflection.intentionHelpfulnessScore,
            ),
            createdAt: Value(existingRow?.createdAt ?? DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
