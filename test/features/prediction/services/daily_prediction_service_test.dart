import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_calculator.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';

void main() {
  test('creates daily prediction', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final snapshotService = DailyFeatureSnapshotService(database: database);
    final recordService = DailyPredictionRecordService(database: database);
    final modelService = EnergyModelService(database: database);
    final service = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: snapshotService,
      predictionRecordService: recordService,
      energyModelService: modelService,
    );
    addTearDown(database.close);
    await modelService.saveActiveModel(
      parameters: _modelParameters(),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );
    final day = DateTime(2026, 6, 28);
    final capturedAt = DateTime(2026, 6, 28, 13, 30);
    final initialEvents = [
      CalendarEvent(
        id: 'study',
        title: 'Study session',
        startTime: DateTime(2026, 6, 28, 9),
        endTime: DateTime(2026, 6, 28, 11),
        category: CalendarEventCategory.focus,
      ),
    ];

    expect(await service.loadInitialPredictionForDay(day), isNull);

    final firstPrediction = await service.loadOrCreateInitialPrediction(
      day: day,
      events: initialEvents,
      capturedAt: capturedAt,
    );
    final secondPrediction = await service.loadOrCreateInitialPrediction(
      day: day,
      events: [
        ...initialEvents,
        CalendarEvent(
          id: 'work',
          title: 'Work meeting',
          startTime: DateTime(2026, 6, 28, 12),
          endTime: DateTime(2026, 6, 28, 16),
          category: CalendarEventCategory.focus,
        ),
      ],
      capturedAt: DateTime(2026, 6, 28, 16),
    );
    final snapshot = await snapshotService.loadInitialPredictionSnapshotForDay(
      day,
    );
    final savedPrediction = await service.loadInitialPredictionForDay(day);

    expect(firstPrediction.predictedCategory, 'low');
    expect(firstPrediction.predictedScore, 0.5);
    expect(firstPrediction.predictionVersion, 'active-logistic-test');
    expect(secondPrediction.id, firstPrediction.id);
    expect(savedPrediction!.id, firstPrediction.id);
    expect(snapshot!.capturedAt, capturedAt);
    expect(snapshot.features.totalScheduledMinutes, 120);
  });

  test('uses active model', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final snapshotService = DailyFeatureSnapshotService(database: database);
    final recordService = DailyPredictionRecordService(database: database);
    final modelService = EnergyModelService(database: database);
    final service = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: snapshotService,
      predictionRecordService: recordService,
      energyModelService: modelService,
    );
    addTearDown(database.close);
    await modelService.saveActiveModel(
      parameters: _modelParameters(
        coefficients: {
          EnergyModelFeature.busyMinutes: 1,
          EnergyModelFeature.backToBackEventCount: 0,
          EnergyModelFeature.longestGapBetweenActivitiesMinutes: 0,
          EnergyModelFeature.maxConsecutiveBlockMinutes: 0,
          EnergyModelFeature.focusMinutes: 0,
          EnergyModelFeature.socialMinutes: 0,
          EnergyModelFeature.lifeAdminMinutes: 0,
          EnergyModelFeature.exerciseMinutes: 0,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );

    final prediction = await service.loadOrCreateInitialPrediction(
      day: DateTime(2026, 6, 28),
      events: [
        CalendarEvent(
          id: 'study',
          title: 'Study session',
          startTime: DateTime(2026, 6, 28, 9),
          endTime: DateTime(2026, 6, 28, 13),
          category: CalendarEventCategory.focus,
        ),
      ],
    );

    expect(prediction.predictionVersion, 'active-logistic-test');
    expect(prediction.predictedScore, closeTo(0.622459, 0.000001));
  });

  test('requires active model', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final recordService = DailyPredictionRecordService(database: database);
    final service = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: recordService,
      energyModelService: EnergyModelService(database: database),
    );
    addTearDown(database.close);
    final day = DateTime(2026, 6, 28);

    await expectLater(
      service.loadOrCreateInitialPrediction(day: day, events: const []),
      throwsA(isA<EnergyModelUnavailableException>()),
    );
    expect(await recordService.loadInitialPredictionForDay(day), isNull);
  });
}

LogisticModelParameters _modelParameters({
  Map<EnergyModelFeature, double>? coefficients,
}) {
  return LogisticModelParameters(
    featureVersion: EnergyModelContract.featureVersion,
    targetVersion: EnergyModelContract.targetVersion,
    modelVersion: 'active-logistic-test',
    intercept: 0,
    coefficients:
        coefficients ??
        {for (final feature in EnergyModelContract.orderedFeatures) feature: 0},
  );
}
