import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/daily_prediction.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/logistic_prediction_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogisticPredictionEngine', () {
    test('uses intercept only', () {
      final engine = LogisticPredictionEngine(parameters: _parameters());

      final prediction = engine.predict(_features());

      expect(prediction.predictedScore, closeTo(0.5, 0.000001));
      expect(prediction.predictedCategory, DailyPredictionCategory.low);
      expect(prediction.predictionVersion, 'test-model-v1');
      expect(prediction.reasons, [
        'Your schedule has limited signals for today\'s forecast.',
      ]);
    });

    test('uses scaled features', () {
      final engine = LogisticPredictionEngine(
        parameters: _parameters(
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
      );

      final prediction = engine.predict(_features(busyMinutes: 240));

      expect(prediction.predictedScore, closeTo(0.622459, 0.000001));
      expect(prediction.predictedCategory, DailyPredictionCategory.low);
      expect(
        prediction.reasons.first,
        'Your schedule includes around 4 hours of planned activities today. '
        'Cal saw this as one of the strongest signals '
        'pointing towards lower energy.',
      );
    });

    test('uses prediction threshold', () {
      final engine = LogisticPredictionEngine(
        parameters: _parameters(intercept: -1),
      );

      final prediction = engine.predict(_features());

      expect(prediction.predictedScore, closeTo(0.268941, 0.000001));
      expect(prediction.predictedCategory, DailyPredictionCategory.sufficient);
    });

    test('keeps sigmoid stable', () {
      final highRiskEngine = LogisticPredictionEngine(
        parameters: _parameters(intercept: 1000),
      );
      final lowRiskEngine = LogisticPredictionEngine(
        parameters: _parameters(intercept: -1000),
      );

      expect(highRiskEngine.predict(_features()).predictedScore, 1);
      expect(lowRiskEngine.predict(_features()).predictedScore, 0);
    });

    test('rejects wrong versions', () {
      expect(
        () => LogisticPredictionEngine(
          parameters: _parameters(featureVersion: 'old-feature-version'),
        ).predict(_features()),
        throwsStateError,
      );
      expect(
        () => LogisticPredictionEngine(
          parameters: _parameters(targetVersion: 'old-target-version'),
        ).predict(_features()),
        throwsStateError,
      );
    });
  });
}

LogisticModelParameters _parameters({
  String featureVersion = EnergyModelContract.featureVersion,
  String targetVersion = EnergyModelContract.targetVersion,
  double intercept = 0,
  Map<EnergyModelFeature, double>? coefficients,
}) {
  return LogisticModelParameters(
    featureVersion: featureVersion,
    targetVersion: targetVersion,
    modelVersion: 'test-model-v1',
    intercept: intercept,
    coefficients:
        coefficients ??
        {for (final feature in EnergyModelContract.orderedFeatures) feature: 0},
  );
}

DailyCalendarFeatures _features({
  int busyMinutes = 0,
  int backToBackEventCount = 0,
  int longestGapBetweenActivitiesMinutes = 0,
  int maxConsecutiveBlockMinutes = 0,
  int focusMinutes = 0,
  int socialMinutes = 0,
  int lifeAdminMinutes = 0,
  int exerciseMinutes = 0,
}) {
  return DailyCalendarFeatures(
    totalEventCount: busyMinutes == 0 ? 0 : 1,
    allDayEventCount: 0,
    totalScheduledMinutes: busyMinutes,
    busyMinutes: busyMinutes,
    focusMinutes: focusMinutes,
    socialMinutes: socialMinutes,
    lifeAdminMinutes: lifeAdminMinutes,
    exerciseMinutes: exerciseMinutes,
    restMinutes: 0,
    backToBackEventCount: backToBackEventCount,
    freeMinutes: 840 - busyMinutes,
    longestGapBetweenActivitiesMinutes: longestGapBetweenActivitiesMinutes,
    maxConsecutiveBlockMinutes: maxConsecutiveBlockMinutes,
    freeSlots: const [],
  );
}
