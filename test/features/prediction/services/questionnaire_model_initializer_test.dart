import 'dart:math' as math;

import 'package:calendar_app/features/onboarding/models/onboarding_questionnaire_answers.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/services/questionnaire_model_initializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnaireModelInitializer', () {
    const initializer = QuestionnaireModelInitializer();

    test('creates initial model', () {
      final model = initializer.createInitialModel(_answers());

      expect(model.featureVersion, EnergyModelContract.featureVersion);
      expect(model.targetVersion, EnergyModelContract.targetVersion);
      expect(model.modelVersion, 'questionnaire-baseline-v2');
      expect(model.coefficients.keys, EnergyModelContract.orderedFeatures);
    });

    test('maps baseline intercept', () {
      expect(
        initializer
            .createInitialModel(_answers(typicalEnergyScore: 1))
            .intercept,
        closeTo(math.log(0.75 / 0.25), 0.000001),
      );
      expect(
        initializer
            .createInitialModel(_answers(typicalEnergyScore: 3))
            .intercept,
        closeTo(0, 0.000001),
      );
      expect(
        initializer
            .createInitialModel(_answers(typicalEnergyScore: 5))
            .intercept,
        closeTo(math.log(0.25 / 0.75), 0.000001),
      );
    });

    test('maps neutral answers', () {
      final model = initializer.createInitialModel(_answers());

      expect(model.orderedCoefficients, everyElement(0));
    });

    test('maps lower-energy answers', () {
      final model = initializer.createInitialModel(
        _answers(
          busyImpactScore: 1,
          backToBackImpactScore: 1,
          longBlockImpactScore: 1,
          focusImpactScore: 1,
          socialImpactScore: 1,
          lifeAdminImpactScore: 1,
          exerciseImpactScore: 1,
        ),
      );

      expect(model.coefficientFor(EnergyModelFeature.busyMinutes), 0.5);
      expect(
        model.coefficientFor(EnergyModelFeature.backToBackEventCount),
        0.5,
      );
      expect(
        model.coefficientFor(EnergyModelFeature.maxConsecutiveBlockMinutes),
        0.5,
      );
      expect(model.coefficientFor(EnergyModelFeature.focusMinutes), 0.5);
      expect(model.coefficientFor(EnergyModelFeature.socialMinutes), 0.5);
      expect(model.coefficientFor(EnergyModelFeature.lifeAdminMinutes), 0.5);
      expect(model.coefficientFor(EnergyModelFeature.exerciseMinutes), 0.5);
    });

    test('maps higher-energy answers', () {
      final model = initializer.createInitialModel(
        _answers(freeGapImpactScore: 5, exerciseImpactScore: 5),
      );

      expect(
        model.coefficientFor(
          EnergyModelFeature.longestGapBetweenActivitiesMinutes,
        ),
        -0.5,
      );
      expect(model.coefficientFor(EnergyModelFeature.exerciseMinutes), -0.5);
    });

    test('keeps coefficient order', () {
      final model = initializer.createInitialModel(
        _answers(
          busyImpactScore: 1,
          backToBackImpactScore: 2,
          freeGapImpactScore: 4,
          longBlockImpactScore: 5,
          focusImpactScore: 1,
          socialImpactScore: 2,
          lifeAdminImpactScore: 4,
          exerciseImpactScore: 5,
        ),
      );

      expect(model.orderedCoefficients, [
        0.5,
        0.25,
        -0.25,
        -0.5,
        0.5,
        0.25,
        -0.25,
        -0.5,
      ]);
    });

    test('rejects invalid answers', () {
      expect(
        () => initializer.createInitialModel(_answers(typicalEnergyScore: 0)),
        throwsRangeError,
      );
      expect(
        () => initializer.createInitialModel(_answers(busyImpactScore: 6)),
        throwsRangeError,
      );
    });
  });
}

OnboardingQuestionnaireAnswers _answers({
  int typicalEnergyScore = 3,
  int busyImpactScore = 3,
  int backToBackImpactScore = 3,
  int longBlockImpactScore = 3,
  int freeGapImpactScore = 3,
  int focusImpactScore = 3,
  int socialImpactScore = 3,
  int lifeAdminImpactScore = 3,
  int exerciseImpactScore = 3,
  int calendarUnderstandingScore = 3,
  int schedulePredictionConfidenceScore = 3,
}) {
  return OnboardingQuestionnaireAnswers(
    typicalEnergyScore: typicalEnergyScore,
    busyImpactScore: busyImpactScore,
    backToBackImpactScore: backToBackImpactScore,
    longBlockImpactScore: longBlockImpactScore,
    freeGapImpactScore: freeGapImpactScore,
    focusImpactScore: focusImpactScore,
    socialImpactScore: socialImpactScore,
    lifeAdminImpactScore: lifeAdminImpactScore,
    exerciseImpactScore: exerciseImpactScore,
    calendarUnderstandingScore: calendarUnderstandingScore,
    schedulePredictionConfidenceScore: schedulePredictionConfidenceScore,
  );
}
