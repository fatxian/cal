import '../../../core/database/app_database.dart';
import '../../calendar/models/calendar_event_category.dart';
import '../../calendar/models/event_energy_impact.dart';
import '../models/weekly_insight_aggregate.dart';

class WeeklyActivityAggregator {
  const WeeklyActivityAggregator();

  List<WeeklyActivitySummary> build({
    required List<EventUserDataItem> eventResponses,
    required List<ManualCalendarEventItem> manualEventResponses,
  }) {
    final counts = <CalendarEventCategory, List<int>>{};
    for (final row in eventResponses) {
      _addResponse(
        counts: counts,
        categoryName: row.category,
        impactScore: row.energyImpactScore,
      );
    }
    for (final row in manualEventResponses) {
      _addResponse(
        counts: counts,
        categoryName: row.category,
        impactScore: row.energyImpactScore,
      );
    }

    final summaries = counts.entries
        .map(
          (entry) => WeeklyActivitySummary(
            category: entry.key.name,
            decreasedCount: entry.value[0],
            unchangedCount: entry.value[1],
            increasedCount: entry.value[2],
          ),
        )
        .toList();
    summaries.sort((first, second) {
      final countComparison = second.totalCount.compareTo(first.totalCount);
      if (countComparison != 0) return countComparison;
      return first.category.compareTo(second.category);
    });
    return summaries;
  }

  void _addResponse({
    required Map<CalendarEventCategory, List<int>> counts,
    required String? categoryName,
    required int? impactScore,
  }) {
    final category = _categoryFromName(categoryName);
    final impact = EventEnergyImpact.fromScore(impactScore);
    if (category == null ||
        category == CalendarEventCategory.notSure ||
        impact == null) {
      return;
    }

    final categoryCounts = counts.putIfAbsent(category, () => [0, 0, 0]);
    categoryCounts[impact.score - 1]++;
  }

  CalendarEventCategory? _categoryFromName(String? name) {
    for (final category in CalendarEventCategory.values) {
      if (category.name == name) return category;
    }
    return null;
  }
}
