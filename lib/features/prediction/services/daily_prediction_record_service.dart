import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/daily_prediction.dart';

class DailyPredictionRecordService {
  const DailyPredictionRecordService({required this.database});

  final AppDatabase database;

  Future<bool> createInitialPredictionIfAbsent({
    required DateTime day,
    required int featureSnapshotId,
    required String predictedCategory,
    required double? predictedScore,
    required List<String> reasons,
    required String predictionVersion,
    DateTime? createdAt,
  }) async {
    final date = dateKey(day);

    return database.transaction(() async {
      final existingPrediction = await (database.select(
        database.dailyPredictionItems,
      )..where((table) => table.date.equals(date))).getSingleOrNull();

      if (existingPrediction != null) return false;

      await database
          .into(database.dailyPredictionItems)
          .insert(
            DailyPredictionItemsCompanion.insert(
              date: date,
              featureSnapshotId: featureSnapshotId,
              predictedCategory: predictedCategory,
              predictedScore: Value(predictedScore),
              reasonsJson: Value(jsonEncode(reasons)),
              predictionVersion: predictionVersion,
              createdAt: Value(createdAt ?? DateTime.now()),
            ),
          );

      return true;
    });
  }

  Future<DailyPrediction?> loadInitialPredictionForDay(DateTime day) async {
    final row = await (database.select(
      database.dailyPredictionItems,
    )..where((table) => table.date.equals(dateKey(day)))).getSingleOrNull();

    if (row == null) return null;

    return DailyPrediction(
      id: row.id,
      day: DateTime.parse(row.date),
      featureSnapshotId: row.featureSnapshotId,
      predictedCategory: row.predictedCategory,
      predictedScore: row.predictedScore,
      reasons: _decodeReasons(row.reasonsJson),
      predictionVersion: row.predictionVersion,
      createdAt: row.createdAt,
      agreementScore: row.agreementScore,
      feedbackUpdatedAt: row.feedbackUpdatedAt,
    );
  }

  Future<void> saveAgreementForDay(
    DateTime day,
    int agreementScore, {
    DateTime? updatedAt,
  }) async {
    if (!DailyPredictionAgreement.isValid(agreementScore)) {
      throw ArgumentError.value(
        agreementScore,
        'agreementScore',
        'Must be between 0 and 2.',
      );
    }

    final updatedRows =
        await (database.update(
          database.dailyPredictionItems,
        )..where((table) => table.date.equals(dateKey(day)))).write(
          DailyPredictionItemsCompanion(
            agreementScore: Value(agreementScore),
            feedbackUpdatedAt: Value(updatedAt ?? DateTime.now()),
          ),
        );

    if (updatedRows == 0) {
      throw StateError('No prediction exists for this day.');
    }
  }

  List<String> _decodeReasons(String reasonsJson) {
    final decoded = jsonDecode(reasonsJson);

    if (decoded is! List) return [];
    return decoded.whereType<String>().toList();
  }
}
