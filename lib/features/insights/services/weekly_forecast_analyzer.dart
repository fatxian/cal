import '../../../core/database/app_database.dart';
import '../models/weekly_insight_aggregate.dart';

class WeeklyForecastAnalyzer {
  const WeeklyForecastAnalyzer();

  WeeklyForecastSummary build({
    required List<ForecastReflectionItem> reflections,
    required List<DailyPredictionItem> predictions,
  }) {
    final supportiveMatchedFactorCounts = <String, int>{};
    final demandingMatchedFactorCounts = <String, int>{};
    final userSupportiveFactorCounts = <String, int>{};
    final userDemandingFactorCounts = <String, int>{};
    final modelSupportiveFactorCounts = <String, int>{};
    final modelDemandingFactorCounts = <String, int>{};
    final differenceCounts = <_ForecastDifferenceKey, int>{};

    for (final reflection in reflections) {
      final modelSupportive = reflection.modelSupportiveFactorType;
      final modelDemanding = reflection.modelDemandingFactorType;
      if (modelSupportive == null && modelDemanding == null) continue;

      _countFactor(userSupportiveFactorCounts, reflection.supportiveFactorType);
      _countFactor(userDemandingFactorCounts, reflection.demandingFactorType);
      if (modelSupportive != null) {
        _countFactor(modelSupportiveFactorCounts, modelSupportive);
      }
      if (modelDemanding != null) {
        _countFactor(modelDemandingFactorCounts, modelDemanding);
      }

      final supportiveMatches =
          modelSupportive != null &&
          reflection.supportiveFactorType == modelSupportive;
      final demandingMatches =
          modelDemanding != null &&
          reflection.demandingFactorType == modelDemanding;
      if (supportiveMatches) {
        supportiveMatchedFactorCounts.update(
          modelSupportive,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
      if (demandingMatches) {
        demandingMatchedFactorCounts.update(
          modelDemanding,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      _countDifferences(
        differenceCounts,
        userSupportive: reflection.supportiveFactorType,
        userDemanding: reflection.demandingFactorType,
        modelSupportive: modelSupportive,
        modelDemanding: modelDemanding,
      );
    }

    var agreementResponseCount = 0;
    var partlyOrFullyAgreedCount = 0;
    for (final prediction in predictions) {
      final score = prediction.agreementScore;
      if (score == null) continue;
      agreementResponseCount++;
      if (score >= 1) partlyOrFullyAgreedCount++;
    }

    return WeeklyForecastSummary(
      agreementResponseCount: agreementResponseCount,
      partlyOrFullyAgreedCount: partlyOrFullyAgreedCount,
      mostFrequentSharedMatch: _mostFrequentSharedMatch(
        supportiveMatchedFactorCounts,
        demandingMatchedFactorCounts,
      ),
      mostFrequentDifference: _mostFrequentDifference(differenceCounts),
      mostFrequentUserSupportiveFactor: _mostFrequentFactorCount(
        userSupportiveFactorCounts,
      ),
      mostFrequentUserDemandingFactor: _mostFrequentFactorCount(
        userDemandingFactorCounts,
      ),
      mostFrequentModelSupportiveFactor: _mostFrequentFactorCount(
        modelSupportiveFactorCounts,
      ),
      mostFrequentModelDemandingFactor: _mostFrequentFactorCount(
        modelDemandingFactorCounts,
      ),
    );
  }

  void _countDifferences(
    Map<_ForecastDifferenceKey, int> counts, {
    required String userSupportive,
    required String userDemanding,
    required String? modelSupportive,
    required String? modelDemanding,
  }) {
    final hasOppositeSupportiveView =
        modelDemanding != null && userSupportive == modelDemanding;
    final hasOppositeDemandingView =
        modelSupportive != null && userDemanding == modelSupportive;

    if (hasOppositeSupportiveView) {
      _countDifference(
        counts,
        userFactor: userSupportive,
        userDirection: WeeklyForecastFactorDirection.increase,
        modelFactor: modelDemanding,
        modelDirection: WeeklyForecastFactorDirection.decrease,
      );
    }
    if (hasOppositeDemandingView) {
      _countDifference(
        counts,
        userFactor: userDemanding,
        userDirection: WeeklyForecastFactorDirection.decrease,
        modelFactor: modelSupportive,
        modelDirection: WeeklyForecastFactorDirection.increase,
      );
    }
    if (!hasOppositeSupportiveView &&
        modelSupportive != null &&
        userSupportive != modelSupportive) {
      _countDifference(
        counts,
        userFactor: userSupportive,
        userDirection: WeeklyForecastFactorDirection.increase,
        modelFactor: modelSupportive,
        modelDirection: WeeklyForecastFactorDirection.increase,
      );
    }
    if (!hasOppositeDemandingView &&
        modelDemanding != null &&
        userDemanding != modelDemanding) {
      _countDifference(
        counts,
        userFactor: userDemanding,
        userDirection: WeeklyForecastFactorDirection.decrease,
        modelFactor: modelDemanding,
        modelDirection: WeeklyForecastFactorDirection.decrease,
      );
    }
  }

  void _countDifference(
    Map<_ForecastDifferenceKey, int> counts, {
    required String userFactor,
    required WeeklyForecastFactorDirection userDirection,
    required String modelFactor,
    required WeeklyForecastFactorDirection modelDirection,
  }) {
    if (!_isMeaningfulFactor(userFactor) || !_isMeaningfulFactor(modelFactor)) {
      return;
    }

    final key = (
      userFactor: userFactor,
      userDirection: userDirection,
      modelFactor: modelFactor,
      modelDirection: modelDirection,
    );
    counts.update(key, (count) => count + 1, ifAbsent: () => 1);
  }

  WeeklyForecastFactorDifference? _mostFrequentDifference(
    Map<_ForecastDifferenceKey, int> counts,
  ) {
    if (counts.isEmpty) return null;

    final entries = counts.entries.toList()
      ..sort((first, second) {
        final countComparison = second.value.compareTo(first.value);
        if (countComparison != 0) return countComparison;

        final firstIsOpposite =
            first.key.userFactor == first.key.modelFactor &&
            first.key.userDirection != first.key.modelDirection;
        final secondIsOpposite =
            second.key.userFactor == second.key.modelFactor &&
            second.key.userDirection != second.key.modelDirection;
        if (firstIsOpposite != secondIsOpposite) {
          return firstIsOpposite ? -1 : 1;
        }

        final userComparison = first.key.userFactor.compareTo(
          second.key.userFactor,
        );
        if (userComparison != 0) return userComparison;
        return first.key.modelFactor.compareTo(second.key.modelFactor);
      });
    final difference = entries.first;

    return WeeklyForecastFactorDifference(
      userFactorType: difference.key.userFactor,
      userDirection: difference.key.userDirection,
      modelFactorType: difference.key.modelFactor,
      modelDirection: difference.key.modelDirection,
      count: difference.value,
    );
  }

  WeeklyForecastFactorMatch? _mostFrequentSharedMatch(
    Map<String, int> supportiveCounts,
    Map<String, int> demandingCounts,
  ) {
    final matches =
        [
          for (final entry in supportiveCounts.entries)
            WeeklyForecastFactorMatch(
              factorType: entry.key,
              direction: WeeklyForecastFactorDirection.increase,
              count: entry.value,
            ),
          for (final entry in demandingCounts.entries)
            WeeklyForecastFactorMatch(
              factorType: entry.key,
              direction: WeeklyForecastFactorDirection.decrease,
              count: entry.value,
            ),
        ]..sort((first, second) {
          final countComparison = second.count.compareTo(first.count);
          if (countComparison != 0) return countComparison;
          final factorComparison = first.factorType.compareTo(
            second.factorType,
          );
          if (factorComparison != 0) return factorComparison;
          return first.direction.index.compareTo(second.direction.index);
        });

    return matches.isEmpty ? null : matches.first;
  }

  void _countFactor(Map<String, int> counts, String factor) {
    if (!_isMeaningfulFactor(factor)) return;
    counts.update(factor, (count) => count + 1, ifAbsent: () => 1);
  }

  bool _isMeaningfulFactor(String factor) {
    return factor != 'nothingStandsOut' &&
        factor != 'notSure' &&
        factor != 'outsideCalendar' &&
        factor != 'unspecified';
  }

  WeeklyFactorCount? _mostFrequentFactorCount(Map<String, int> counts) {
    if (counts.isEmpty) return null;
    final entries = counts.entries.toList()
      ..sort((first, second) {
        final countComparison = second.value.compareTo(first.value);
        if (countComparison != 0) return countComparison;
        return first.key.compareTo(second.key);
      });
    final entry = entries.first;
    return WeeklyFactorCount(factorType: entry.key, count: entry.value);
  }
}

typedef _ForecastDifferenceKey = ({
  String userFactor,
  WeeklyForecastFactorDirection userDirection,
  String modelFactor,
  WeeklyForecastFactorDirection modelDirection,
});
