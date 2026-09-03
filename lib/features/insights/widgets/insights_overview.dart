part of '../screens/insights_screen.dart';

class _WeeklyInsights extends StatelessWidget {
  const _WeeklyInsights({required this.summary});

  final WeeklyInsightSummary summary;

  @override
  Widget build(BuildContext context) {
    final intentionSections = summary.sections
        .where((section) => section.title == 'Your intentions')
        .toList(growable: false);
    final patternSections = summary.sections
        .where((section) => section.title == 'Cal saw a pattern this week')
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeeklyEnergyStrip(summary: summary),
        const SizedBox(height: 18),
        _WeeklyInsightCards(
          sections: patternSections,
          intentionSummaries: summary.intentionSummaries,
        ),
        const SizedBox(height: 18),
        _ForecastComparisonCard(comparison: summary.forecastComparison),
        const SizedBox(height: 18),
        _WeeklyInsightCards(
          sections: intentionSections,
          intentionSummaries: summary.intentionSummaries,
        ),
        const SizedBox(height: 18),
        _ActivityEnergyCard(summaries: summary.activityEnergySummaries),
      ],
    );
  }
}

class _AllTimeInsights extends StatelessWidget {
  const _AllTimeInsights({required this.summary});

  final WeeklyInsightSummary summary;

  @override
  Widget build(BuildContext context) {
    final modelSections = summary.sections
        .where((section) => section.title == 'What Cal has learned over time')
        .toList(growable: false);

    return _WeeklyInsightCards(
      sections: modelSections,
      intentionSummaries: summary.intentionSummaries,
    );
  }
}

class _WeekSelector extends StatelessWidget {
  const _WeekSelector({
    required this.weekStart,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime weekStart;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.textSecondary,
          iconSize: 32,
        ),
        Expanded(
          child: Center(
            child: Text(
              _formatWeekRange(weekStart, weekEnd),
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.textSecondary,
          iconSize: 32,
        ),
      ],
    );
  }

  String _formatWeekRange(DateTime start, DateTime end) {
    final startMonth = _monthLabel(start.month);
    final endMonth = _monthLabel(end.month);

    if (start.year == end.year && start.month == end.month) {
      return '$startMonth ${start.day} - ${end.day}, ${start.year}';
    }

    if (start.year == end.year) {
      return '$startMonth ${start.day} - $endMonth ${end.day}, ${start.year}';
    }

    return '$startMonth ${start.day}, ${start.year} - '
        '$endMonth ${end.day}, ${end.year}';
  }

  String _monthLabel(int month) {
    const labels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return labels[month - 1];
  }
}
