import '../models/daily_intention.dart';
import '../models/forecast_reflection_option.dart';

class ForecastIntentionOptionPages {
  const ForecastIntentionOptionPages({
    required this.pages,
    required this.noChangeOption,
  });

  final List<List<ForecastIntentionOption>> pages;
  final ForecastIntentionOption? noChangeOption;

  int pageContaining(ForecastIntentionOption? option) {
    if (option == null ||
        option.adjustment.type == DailyAdjustmentType.noChange) {
      return -1;
    }

    for (var index = 0; index < pages.length; index++) {
      if (pages[index].contains(option)) return index;
    }

    return -1;
  }
}

class ForecastIntentionOptionPageBuilder {
  const ForecastIntentionOptionPageBuilder({this.pageSize = 3})
    : assert(pageSize > 0);

  final int pageSize;

  ForecastIntentionOptionPages build(List<ForecastIntentionOption> options) {
    ForecastIntentionOption? noChangeOption;
    final ideaOptions = <ForecastIntentionOption>[];

    for (final option in options) {
      if (option.adjustment.type == DailyAdjustmentType.noChange) {
        noChangeOption ??= option;
      } else {
        ideaOptions.add(option);
      }
    }

    final remaining = List<ForecastIntentionOption>.from(ideaOptions);
    final pages = <List<ForecastIntentionOption>>[];

    while (remaining.isNotEmpty) {
      final page = <ForecastIntentionOption>[];
      while (remaining.isNotEmpty && page.length < pageSize) {
        final nextIndex = _mostDistinctOptionIndex(remaining, page);
        page.add(remaining.removeAt(nextIndex));
      }
      pages.add(page);
    }

    if (pages.isNotEmpty &&
        pages.last.length < pageSize &&
        ideaOptions.length >= pageSize) {
      final lastPage = pages.last;
      final fillCandidates = ideaOptions
          .where((option) => !lastPage.contains(option))
          .toList();
      while (lastPage.length < pageSize && fillCandidates.isNotEmpty) {
        final nextIndex = _mostDistinctOptionIndex(fillCandidates, lastPage);
        lastPage.add(fillCandidates.removeAt(nextIndex));
      }
    }

    return ForecastIntentionOptionPages(
      pages: pages,
      noChangeOption: noChangeOption,
    );
  }

  int _mostDistinctOptionIndex(
    List<ForecastIntentionOption> candidates,
    List<ForecastIntentionOption> page,
  ) {
    if (page.isEmpty) return 0;

    var bestIndex = 0;
    var bestScore = -1;
    final usedFamilies = page.map(_ideaFamily).toSet();
    final usedFactors = page.map((option) => option.factor.type).toSet();
    final usedSources = page.map((option) => option.sourceLabel).toSet();

    for (var index = 0; index < candidates.length; index++) {
      final option = candidates[index];
      var score = 0;
      // prefer a different action family, then factor and source, so one page
      // does not show several very similar intentions
      if (!usedFamilies.contains(_ideaFamily(option))) score += 4;
      if (!usedFactors.contains(option.factor.type)) score += 2;
      if (!usedSources.contains(option.sourceLabel)) score += 1;
      if (score > bestScore) {
        bestIndex = index;
        bestScore = score;
      }
    }

    return bestIndex;
  }

  _IntentionIdeaFamily _ideaFamily(ForecastIntentionOption option) {
    return switch (option.adjustment.type) {
      DailyAdjustmentType.protectBreak ||
      DailyAdjustmentType.keepTimeFree ||
      DailyAdjustmentType.screenBreak ||
      DailyAdjustmentType.quietPause => _IntentionIdeaFamily.pause,
      DailyAdjustmentType.shortWalk ||
      DailyAdjustmentType.stretch => _IntentionIdeaFamily.movement,
      DailyAdjustmentType.focusSession => _IntentionIdeaFamily.focus,
      DailyAdjustmentType.socialMoment => _IntentionIdeaFamily.social,
      DailyAdjustmentType.lifeAdminTask => _IntentionIdeaFamily.lifeAdmin,
      DailyAdjustmentType.leaveBuffer => _IntentionIdeaFamily.buffer,
      DailyAdjustmentType.keepPlan => _IntentionIdeaFamily.keepPlan,
      DailyAdjustmentType.noticeEnergy => _IntentionIdeaFamily.openChoice,
      DailyAdjustmentType.noChange => _IntentionIdeaFamily.noChange,
      DailyAdjustmentType.unspecified => _IntentionIdeaFamily.other,
    };
  }
}

enum _IntentionIdeaFamily {
  pause,
  movement,
  focus,
  social,
  lifeAdmin,
  buffer,
  keepPlan,
  openChoice,
  noChange,
  other,
}
