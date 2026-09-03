import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/energy_model_metadata.dart';
import '../models/energy_model_feature.dart';
import '../models/logistic_model_parameters.dart';

abstract final class EnergyModelSource {
  static const String questionnaireBaseline = 'questionnaire_baseline';
  static const String personalisedLogistic = 'personalised_logistic';
}

class EnergyModelService {
  const EnergyModelService({required this.database});

  final AppDatabase database;

  Future<void> saveActiveModel({
    required LogisticModelParameters parameters,
    required String modelSource,
    DateTime? savedAt,
  }) async {
    final now = savedAt ?? DateTime.now();

    // keep model history while ensuring exactly one model remains active
    await database.transaction(() async {
      await database
          .update(database.energyModelItems)
          .write(const EnergyModelItemsCompanion(isActive: Value(false)));

      await database
          .into(database.energyModelItems)
          .insert(
            EnergyModelItemsCompanion.insert(
              modelVersion: parameters.modelVersion,
              modelSource: modelSource,
              featureVersion: parameters.featureVersion,
              targetVersion: parameters.targetVersion,
              intercept: parameters.intercept,
              coefficientsJson: _encodeCoefficients(parameters),
              isActive: const Value(true),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    });
  }

  Future<LogisticModelParameters?> loadActiveModel() async {
    final row = await (database.select(
      database.energyModelItems,
    )..where((table) => table.isActive.equals(true))).getSingleOrNull();

    if (row == null) return null;

    return LogisticModelParameters(
      featureVersion: row.featureVersion,
      targetVersion: row.targetVersion,
      modelVersion: row.modelVersion,
      intercept: row.intercept,
      coefficients: _decodeCoefficients(row.coefficientsJson),
    );
  }

  Future<EnergyModelMetadata?> loadActiveModelMetadata() async {
    final row = await (database.select(
      database.energyModelItems,
    )..where((table) => table.isActive.equals(true))).getSingleOrNull();

    if (row == null) return null;

    return EnergyModelMetadata(
      modelVersion: row.modelVersion,
      modelSource: row.modelSource,
      featureVersion: row.featureVersion,
      targetVersion: row.targetVersion,
      createdAt: row.createdAt,
    );
  }

  Future<bool> activateLatestQuestionnaireBaseline() async {
    final baseline =
        await (database.select(database.energyModelItems)
              ..where(
                (table) => table.modelSource.equals(
                  EnergyModelSource.questionnaireBaseline,
                ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.id)])
              ..limit(1))
            .getSingleOrNull();
    if (baseline == null) return false;

    await database.transaction(() async {
      await database
          .update(database.energyModelItems)
          .write(const EnergyModelItemsCompanion(isActive: Value(false)));
      await (database.update(
        database.energyModelItems,
      )..where((table) => table.id.equals(baseline.id))).write(
        EnergyModelItemsCompanion(
          isActive: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });

    return true;
  }

  String _encodeCoefficients(LogisticModelParameters parameters) {
    final values = {
      for (final feature in EnergyModelContract.orderedFeatures)
        feature.key: parameters.coefficientFor(feature),
    };

    return jsonEncode(values);
  }

  Map<EnergyModelFeature, double> _decodeCoefficients(String json) {
    final decoded = jsonDecode(json) as Map<String, dynamic>;

    return {
      for (final feature in EnergyModelContract.orderedFeatures)
        feature: (decoded[feature.key] as num?)?.toDouble() ?? 0,
    };
  }
}
