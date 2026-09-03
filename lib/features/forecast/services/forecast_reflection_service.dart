import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../models/daily_intention.dart';
import '../models/forecast_reflection.dart';

class ForecastReflectionService {
  const ForecastReflectionService({required this.database});

  final AppDatabase database;

  Future<ForecastReflection?> loadReflectionForDay(DateTime day) async {
    final row = await (database.select(
      database.forecastReflectionItems,
    )..where((table) => table.date.equals(dateKey(day)))).getSingleOrNull();

    if (row == null) return null;

    return ForecastReflection(
      predictionId: row.predictionId,
      supportiveFactor: _decodeFactor(
        row.supportiveFactorType,
        row.supportiveFactorLabel,
      ),
      demandingFactor: _decodeFactor(
        row.demandingFactorType,
        row.demandingFactorLabel,
      ),
      modelSupportiveFactor: _decodeOptionalFactor(
        row.modelSupportiveFactorType,
        row.modelSupportiveFactorLabel,
      ),
      modelDemandingFactor: _decodeOptionalFactor(
        row.modelDemandingFactorType,
        row.modelDemandingFactorLabel,
      ),
      revealedAt: row.revealedAt,
    );
  }

  Future<void> saveReflectionForDay({
    required DateTime day,
    required int predictionId,
    required ForecastFactor supportiveFactor,
    required ForecastFactor demandingFactor,
    ForecastFactor? modelSupportiveFactor,
    ForecastFactor? modelDemandingFactor,
    DateTime? revealedAt,
  }) async {
    final timestamp = revealedAt ?? DateTime.now();

    await database
        .into(database.forecastReflectionItems)
        .insert(
          ForecastReflectionItemsCompanion.insert(
            date: dateKey(day),
            predictionId: predictionId,
            supportiveFactorType: supportiveFactor.type.name,
            supportiveFactorLabel: supportiveFactor.label,
            demandingFactorType: demandingFactor.type.name,
            demandingFactorLabel: demandingFactor.label,
            modelSupportiveFactorType: Value(modelSupportiveFactor?.type.name),
            modelSupportiveFactorLabel: Value(modelSupportiveFactor?.label),
            modelDemandingFactorType: Value(modelDemandingFactor?.type.name),
            modelDemandingFactorLabel: Value(modelDemandingFactor?.label),
            revealedAt: timestamp,
            updatedAt: Value(timestamp),
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

  ForecastFactor _decodeFactor(String typeValue, String storedLabel) {
    final type = _decodeFactorType(typeValue);
    return ForecastFactor(
      type: type,
      label: _canonicalLabel(type, storedLabel),
    );
  }

  ForecastFactor? _decodeOptionalFactor(String? type, String? label) {
    if (type == null || label == null) return null;
    return _decodeFactor(type, label);
  }

  String _canonicalLabel(ForecastFactorType type, String storedLabel) {
    return switch (type) {
      ForecastFactorType.scheduledTime =>
        EnergyModelFeature.busyMinutes.displayLabel,
      ForecastFactorType.backToBackEvents =>
        EnergyModelFeature.backToBackEventCount.displayLabel,
      ForecastFactorType.longestGapBetweenActivities =>
        EnergyModelFeature.longestGapBetweenActivitiesMinutes.displayLabel,
      ForecastFactorType.longestScheduledBlock =>
        EnergyModelFeature.maxConsecutiveBlockMinutes.displayLabel,
      ForecastFactorType.focusTime =>
        EnergyModelFeature.focusMinutes.displayLabel,
      ForecastFactorType.socialTime =>
        EnergyModelFeature.socialMinutes.displayLabel,
      ForecastFactorType.lifeAdminTasks =>
        EnergyModelFeature.lifeAdminMinutes.displayLabel,
      ForecastFactorType.exercise =>
        EnergyModelFeature.exerciseMinutes.displayLabel,
      _ => storedLabel,
    };
  }
}
