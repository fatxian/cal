import '../../calendar/models/calendar_event.dart';
import '../../calendar/utils/calendar_snapshot.dart';
import '../models/daily_feature_snapshot.dart';
import '../models/daily_prediction.dart';
import 'daily_feature_calculator.dart';
import 'daily_feature_snapshot_service.dart';
import 'daily_prediction_engine.dart';
import 'daily_prediction_record_service.dart';
import 'energy_model_service.dart';
import 'logistic_prediction_engine.dart';

class EnergyModelUnavailableException implements Exception {
  const EnergyModelUnavailableException();

  @override
  String toString() => 'Cal is not ready yet.';
}

class DailyPredictionService {
  const DailyPredictionService({
    required this.featureCalculator,
    required this.featureSnapshotService,
    required this.predictionRecordService,
    required this.energyModelService,
  });

  final DailyFeatureCalculator featureCalculator;
  final DailyFeatureSnapshotService featureSnapshotService;
  final DailyPredictionRecordService predictionRecordService;
  final EnergyModelService energyModelService;

  Future<DailyPrediction?> loadInitialPredictionForDay(DateTime day) {
    return predictionRecordService.loadInitialPredictionForDay(day);
  }

  Future<DailyFeatureSnapshot?> loadInitialFeatureSnapshotForDay(DateTime day) {
    return featureSnapshotService.loadInitialPredictionSnapshotForDay(day);
  }

  Future<void> saveAgreementForDay(DateTime day, int agreementScore) {
    return predictionRecordService.saveAgreementForDay(day, agreementScore);
  }

  Future<DailyPrediction> loadOrCreateInitialPrediction({
    required DateTime day,
    required List<CalendarEvent> events,
    DateTime? capturedAt,
  }) async {
    // return prediction immediately if it's already been computed
    final existingPrediction = await predictionRecordService
        .loadInitialPredictionForDay(day);
    if (existingPrediction != null) return existingPrediction;

    // fetch or compute the required daily calendar features snapshot
    var snapshot = await featureSnapshotService
        .loadInitialPredictionSnapshotForDay(day);
    final timestamp = capturedAt ?? DateTime.now();

    if (snapshot == null) {
      final features = featureCalculator.calculate(day: day, events: events);

      await featureSnapshotService.createInitialPredictionSnapshotIfAbsent(
        day: day,
        features: features,
        calendarSnapshotKey: createCalendarSnapshotKey(events),
        analysisStartHour: featureCalculator.analysisStartHour,
        analysisEndHour: featureCalculator.analysisEndHour,
        capturedAt: timestamp,
      );
      snapshot = await featureSnapshotService
          .loadInitialPredictionSnapshotForDay(day);
    }

    if (snapshot == null) {
      throw StateError('Could not create the initial feature snapshot.');
    }

    // run prediction engine and save output record to database
    await _createPrediction(day, snapshot, timestamp);

    // reload and return the newly created prediction
    final prediction = await predictionRecordService
        .loadInitialPredictionForDay(day);
    if (prediction == null) {
      throw StateError('Could not create the initial prediction.');
    }

    return prediction;
  }

  Future<void> _createPrediction(
    DateTime day,
    DailyFeatureSnapshot snapshot,
    DateTime createdAt,
  ) async {
    final result = await _predict(snapshot);

    await predictionRecordService.createInitialPredictionIfAbsent(
      day: day,
      featureSnapshotId: snapshot.id,
      predictedCategory: result.predictedCategory,
      predictedScore: result.predictedScore,
      reasons: result.reasons,
      predictionVersion: result.predictionVersion,
      createdAt: createdAt,
    );
  }

  Future<DailyPredictionResult> _predict(DailyFeatureSnapshot snapshot) async {
    final activeModel = await energyModelService.loadActiveModel();
    if (activeModel == null) {
      throw const EnergyModelUnavailableException();
    }

    return LogisticPredictionEngine(
      parameters: activeModel,
    ).predict(snapshot.features);
  }
}
