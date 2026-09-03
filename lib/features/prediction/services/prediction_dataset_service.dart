import '../../../core/database/app_database.dart';
import '../models/daily_calendar_features.dart';
import '../models/energy_model_feature.dart';
import '../models/training_sample.dart';

class PredictionDatasetService {
  const PredictionDatasetService({required this.database});

  final AppDatabase database;

  Future<int> countCompletedSamples() async {
    return (await loadCompletedSamples()).length;
  }

  Future<List<TrainingSample>> loadCompletedSamples() async {
    final snapshotRows = await database
        .select(database.dailyFeatureSnapshotItems)
        .get();
    final predictionRows = await database
        .select(database.dailyPredictionItems)
        .get();
    final reflectionRows = await database
        .select(database.dailyReflectionItems)
        .get();

    final predictionsByDate = {for (final row in predictionRows) row.date: row};
    final reflectionsByDate = {for (final row in reflectionRows) row.date: row};

    final samples = <TrainingSample>[];

    // require the original feature snapshot, its prediction record, and the
    // user's end-of-day energy reflection for each training observation
    for (final snapshot in snapshotRows) {
      final prediction = predictionsByDate[snapshot.date];
      final reflection = reflectionsByDate[snapshot.date];
      if (prediction == null || reflection == null) continue;

      samples.add(
        TrainingSample(
          day: DateTime.parse(snapshot.date),
          featureSnapshotId: snapshot.id,
          predictionId: prediction.id,
          features: _featuresFromSnapshot(snapshot),
          energyScore: reflection.energyScore,
          lowEnergyLabel: EnergyModelContract.lowEnergyLabelFromEnergyScore(
            reflection.energyScore,
          ),
          predictedScore: prediction.predictedScore,
          predictionVersion: prediction.predictionVersion,
          predictionAgreementScore: prediction.agreementScore,
          intentionCompletionScore: reflection.intentionCompletionScore,
          intentionHelpfulnessScore: reflection.intentionHelpfulnessScore,
        ),
      );
    }

    samples.sort((first, second) => first.day.compareTo(second.day));
    return samples;
  }

  DailyCalendarFeatures _featuresFromSnapshot(DailyFeatureSnapshotItem row) {
    return DailyCalendarFeatures(
      totalEventCount: row.totalEventCount,
      allDayEventCount: row.allDayEventCount,
      totalScheduledMinutes: row.totalScheduledMinutes,
      busyMinutes: row.busyMinutes,
      focusMinutes: row.focusMinutes,
      socialMinutes: row.socialMinutes,
      lifeAdminMinutes: row.lifeAdminMinutes,
      exerciseMinutes: row.exerciseMinutes,
      restMinutes: row.restMinutes,
      backToBackEventCount: row.backToBackEventCount,
      freeMinutes: row.freeMinutes,
      longestGapBetweenActivitiesMinutes:
          row.longestGapBetweenActivitiesMinutes,
      maxConsecutiveBlockMinutes: row.maxConsecutiveBlockMinutes,
      freeSlots: const [],
    );
  }
}
