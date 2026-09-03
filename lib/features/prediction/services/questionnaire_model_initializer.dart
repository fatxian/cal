import 'dart:math' as math;

import '../../onboarding/models/onboarding_questionnaire_answers.dart';
import '../models/energy_model_feature.dart';
import '../models/logistic_model_parameters.dart';

class QuestionnaireModelInitializer {
  const QuestionnaireModelInitializer({
    this.modelVersion = 'questionnaire-baseline-v2',
    this.maxCoefficientMagnitude = 0.5,
  });

  final String modelVersion;
  final double maxCoefficientMagnitude;

  LogisticModelParameters createInitialModel(
    OnboardingQuestionnaireAnswers answers,
  ) {
    return LogisticModelParameters(
      featureVersion: EnergyModelContract.featureVersion,
      targetVersion: EnergyModelContract.targetVersion,
      modelVersion: modelVersion,
      intercept: _interceptFromTypicalEnergy(answers.typicalEnergyScore),
      coefficients: {
        EnergyModelFeature.busyMinutes: _coefficientFromImpactScore(
          answers.busyImpactScore,
        ),
        EnergyModelFeature.backToBackEventCount: _coefficientFromImpactScore(
          answers.backToBackImpactScore,
        ),
        EnergyModelFeature.longestGapBetweenActivitiesMinutes:
            _coefficientFromImpactScore(answers.freeGapImpactScore),
        EnergyModelFeature.maxConsecutiveBlockMinutes:
            _coefficientFromImpactScore(answers.longBlockImpactScore),
        EnergyModelFeature.focusMinutes: _coefficientFromImpactScore(
          answers.focusImpactScore,
        ),
        EnergyModelFeature.socialMinutes: _coefficientFromImpactScore(
          answers.socialImpactScore,
        ),
        EnergyModelFeature.lifeAdminMinutes: _coefficientFromImpactScore(
          answers.lifeAdminImpactScore,
        ),
        EnergyModelFeature.exerciseMinutes: _coefficientFromImpactScore(
          answers.exerciseImpactScore,
        ),
      },
    );
  }

  double _interceptFromTypicalEnergy(int score) {
    _checkQuestionnaireScore(score);
    final lowEnergyProbability = switch (score) {
      1 => 0.750,
      2 => 0.625,
      3 => 0.500,
      4 => 0.375,
      5 => 0.250,
      _ => throw StateError('Questionnaire score should already be checked.'),
    };

    return math.log(lowEnergyProbability / (1 - lowEnergyProbability));
  }

  double _coefficientFromImpactScore(int score) {
    _checkQuestionnaireScore(score);

    return ((3 - score) / 2) * maxCoefficientMagnitude;
  }

  void _checkQuestionnaireScore(int score) {
    if (score < 1 || score > 5) {
      throw RangeError.range(score, 1, 5, 'score');
    }
  }
}
