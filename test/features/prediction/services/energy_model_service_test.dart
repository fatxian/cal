import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late EnergyModelService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = EnergyModelService(database: database);
  });

  tearDown(() => database.close());

  test('saves active model', () async {
    await service.saveActiveModel(
      parameters: _parameters(
        intercept: -0.4,
        coefficients: {
          EnergyModelFeature.busyMinutes: 0.5,
          EnergyModelFeature.backToBackEventCount: 0.25,
          EnergyModelFeature.longestGapBetweenActivitiesMinutes: -0.5,
          EnergyModelFeature.maxConsecutiveBlockMinutes: 0.3,
          EnergyModelFeature.focusMinutes: 0.1,
          EnergyModelFeature.socialMinutes: -0.2,
          EnergyModelFeature.lifeAdminMinutes: 0.4,
          EnergyModelFeature.exerciseMinutes: -0.3,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
      savedAt: DateTime(2026, 7, 11, 9),
    );

    final loaded = await service.loadActiveModel();

    expect(loaded, isNotNull);
    expect(loaded!.modelVersion, 'model-v1');
    expect(loaded.featureVersion, EnergyModelContract.featureVersion);
    expect(loaded.targetVersion, EnergyModelContract.targetVersion);
    expect(loaded.intercept, -0.4);
    expect(loaded.orderedCoefficients, [
      0.5,
      0.25,
      -0.5,
      0.3,
      0.1,
      -0.2,
      0.4,
      -0.3,
    ]);

    final metadata = await service.loadActiveModelMetadata();

    expect(metadata!.modelVersion, 'model-v1');
    expect(metadata.modelSource, EnergyModelSource.questionnaireBaseline);
    expect(metadata.createdAt, DateTime(2026, 7, 11, 9));
  });

  test('keeps latest model active', () async {
    await service.saveActiveModel(
      parameters: _parameters(modelVersion: 'first-model', intercept: 0.1),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );
    await service.saveActiveModel(
      parameters: _parameters(modelVersion: 'second-model', intercept: 0.2),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );

    final loaded = await service.loadActiveModel();
    final rows = await database.select(database.energyModelItems).get();

    expect(loaded!.modelVersion, 'second-model');
    expect(rows.where((row) => row.isActive), hasLength(1));
  });
}

LogisticModelParameters _parameters({
  String modelVersion = 'model-v1',
  double intercept = 0,
  Map<EnergyModelFeature, double>? coefficients,
}) {
  return LogisticModelParameters(
    featureVersion: EnergyModelContract.featureVersion,
    targetVersion: EnergyModelContract.targetVersion,
    modelVersion: modelVersion,
    intercept: intercept,
    coefficients:
        coefficients ??
        {for (final feature in EnergyModelContract.orderedFeatures) feature: 0},
  );
}
