import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../../prediction/models/energy_model_metadata.dart';
import '../../prediction/models/logistic_model_parameters.dart';
import '../../prediction/models/training_sample.dart';
import '../../prediction/services/energy_model_service.dart';
import '../../prediction/services/prediction_dataset_service.dart';

class WeeklyInsightRepository {
  const WeeklyInsightRepository({required this.database});

  final AppDatabase database;

  Future<WeeklyInsightData> load(DateTime weekStart) async {
    final normalizedWeekStart = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final weekEnd = normalizedWeekStart.add(const Duration(days: 6));
    final previousWeekStart = normalizedWeekStart.subtract(
      const Duration(days: 7),
    );
    final previousWeekEnd = normalizedWeekStart.subtract(
      const Duration(days: 1),
    );

    final startDate = dateKey(normalizedWeekStart);
    final endDate = dateKey(weekEnd);
    final previousStartDate = dateKey(previousWeekStart);
    final previousEndDate = dateKey(previousWeekEnd);

    final reflections =
        await (database.select(database.dailyReflectionItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final snapshots =
        await (database.select(database.dailyFeatureSnapshotItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final eventResponses =
        await (database.select(database.eventUserDataItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final manualEventResponses =
        await (database.select(database.manualCalendarEventItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final intentions =
        await (database.select(database.dailyIntentionItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final predictions =
        await (database.select(database.dailyPredictionItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final forecastReflections =
        await (database.select(database.forecastReflectionItems)..where(
              (table) =>
                  table.date.isBetween(Variable(startDate), Variable(endDate)),
            ))
            .get();
    final previousReflections =
        await (database.select(database.dailyReflectionItems)..where(
              (table) => table.date.isBetween(
                Variable(previousStartDate),
                Variable(previousEndDate),
              ),
            ))
            .get();

    final modelService = EnergyModelService(database: database);
    final activeModel = await modelService.loadActiveModel();
    final activeModelMetadata = await modelService.loadActiveModelMetadata();
    final completedSamples = await PredictionDatasetService(
      database: database,
    ).loadCompletedSamples();

    return WeeklyInsightData(
      weekStart: normalizedWeekStart,
      reflections: reflections,
      snapshots: snapshots,
      eventResponses: eventResponses,
      manualEventResponses: manualEventResponses,
      intentions: intentions,
      predictions: predictions,
      forecastReflections: forecastReflections,
      previousReflections: previousReflections,
      activeModel: activeModel,
      activeModelMetadata: activeModelMetadata,
      completedSamples: completedSamples,
    );
  }
}

class WeeklyInsightData {
  const WeeklyInsightData({
    required this.weekStart,
    required this.reflections,
    required this.snapshots,
    required this.eventResponses,
    required this.manualEventResponses,
    required this.intentions,
    required this.predictions,
    required this.forecastReflections,
    required this.previousReflections,
    required this.activeModel,
    required this.activeModelMetadata,
    required this.completedSamples,
  });

  final DateTime weekStart;
  final List<DailyReflectionItem> reflections;
  final List<DailyFeatureSnapshotItem> snapshots;
  final List<EventUserDataItem> eventResponses;
  final List<ManualCalendarEventItem> manualEventResponses;
  final List<DailyIntentionItem> intentions;
  final List<DailyPredictionItem> predictions;
  final List<ForecastReflectionItem> forecastReflections;
  final List<DailyReflectionItem> previousReflections;
  final LogisticModelParameters? activeModel;
  final EnergyModelMetadata? activeModelMetadata;
  final List<TrainingSample> completedSamples;
}
