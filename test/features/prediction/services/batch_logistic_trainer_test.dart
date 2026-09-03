import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/daily_prediction.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/training_sample.dart';
import 'package:calendar_app/features/prediction/services/batch_logistic_trainer.dart';
import 'package:calendar_app/features/prediction/services/logistic_prediction_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BatchLogisticTrainer', () {
    const trainer = BatchLogisticTrainer();

    test('rejects too few samples', () {
      expect(
        () => trainer.train([
          for (var index = 0; index < 6; index++)
            _sample(index, busyMinutes: index.isEven ? 480 : 0),
        ]),
        throwsStateError,
      );
    });

    test('rejects one class', () {
      expect(
        () => trainer.train([
          for (var index = 0; index < 7; index++)
            _sample(index, energyScore: 1, busyMinutes: 480),
        ]),
        throwsStateError,
      );
    });

    test('learns busy-day pattern', () {
      final model = trainer.train(_busyScheduleSamples());
      final engine = LogisticPredictionEngine(parameters: model);

      final quietDay = engine.predict(_features(busyMinutes: 0));
      final busyDay = engine.predict(_features(busyMinutes: 480));

      expect(model.coefficientFor(EnergyModelFeature.busyMinutes), isPositive);
      expect(busyDay.predictedScore!, greaterThan(quietDay.predictedScore!));
      expect(busyDay.predictedCategory, DailyPredictionCategory.low);
      expect(quietDay.predictedCategory, DailyPredictionCategory.sufficient);
    });
  });
}

List<TrainingSample> _busyScheduleSamples() {
  return [
    _sample(0, energyScore: 1, busyMinutes: 480),
    _sample(1, energyScore: 2, busyMinutes: 420),
    _sample(2, energyScore: 2, busyMinutes: 360),
    _sample(3, energyScore: 1, busyMinutes: 480),
    _sample(4, energyScore: 4, busyMinutes: 0),
    _sample(5, energyScore: 5, busyMinutes: 30),
    _sample(6, energyScore: 4, busyMinutes: 60),
    _sample(7, energyScore: 3, busyMinutes: 90),
  ];
}

TrainingSample _sample(
  int index, {
  int energyScore = 4,
  required int busyMinutes,
}) {
  return TrainingSample(
    day: DateTime(2026, 7, index + 1),
    featureSnapshotId: index + 1,
    predictionId: index + 1,
    features: _features(busyMinutes: busyMinutes),
    energyScore: energyScore,
    lowEnergyLabel: EnergyModelContract.lowEnergyLabelFromEnergyScore(
      energyScore,
    ),
    predictionVersion: 'test-prediction',
  );
}

DailyCalendarFeatures _features({required int busyMinutes}) {
  return DailyCalendarFeatures(
    totalEventCount: busyMinutes == 0 ? 0 : 1,
    allDayEventCount: 0,
    totalScheduledMinutes: busyMinutes,
    busyMinutes: busyMinutes,
    focusMinutes: 0,
    socialMinutes: 0,
    lifeAdminMinutes: 0,
    exerciseMinutes: 0,
    restMinutes: 0,
    backToBackEventCount: 0,
    freeMinutes: 840 - busyMinutes,
    longestGapBetweenActivitiesMinutes: 180,
    maxConsecutiveBlockMinutes: busyMinutes,
    freeSlots: const [],
  );
}
