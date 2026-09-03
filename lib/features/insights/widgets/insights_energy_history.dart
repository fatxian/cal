part of '../screens/insights_screen.dart';

class _WeeklyEnergyStrip extends StatefulWidget {
  const _WeeklyEnergyStrip({required this.summary});

  final WeeklyInsightSummary summary;

  @override
  State<_WeeklyEnergyStrip> createState() => _WeeklyEnergyStripState();
}

class _WeeklyEnergyStripState extends State<_WeeklyEnergyStrip> {
  bool isExpanded = false;

  WeeklyInsightSummary get summary => widget.summary;

  @override
  void didUpdateWidget(covariant _WeeklyEnergyStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.summary.weekStart != widget.summary.weekStart) {
      isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StandaloneCardTitle(
              title: 'Energy history',
              icon: Icons.bolt_outlined,
              isLocked: false,
              subtitle: 'Based on energy responses from Daily Reflection',
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: summary.energyDays
                  .map((day) => _WeeklyEnergyDay(day: day))
                  .toList(growable: false),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 20),
              _EnergyHistoryStat(
                label: 'Days reflected on',
                value: '${summary.reflectionCount} of 7',
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.forestGreen,
                iconBackground: const Color(0xFFEAF3DF),
              ),
              const Divider(height: 1),
              _EnergyHistoryStat(
                label: 'Lower-energy days',
                value: '${summary.lowEnergyCount}',
                icon: Icons.arrow_downward,
                iconColor: const Color(0xFFE56F32),
                iconBackground: const Color(0xFFFCE6D8),
              ),
              const Divider(height: 1),
              _EnergyHistoryStat(
                label: 'Average energy level',
                value: _averageValue(),
                icon: Icons.bar_chart_rounded,
                iconColor: const Color(0xFF3978B8),
                iconBackground: const Color(0xFFE3F0FA),
              ),
              const Divider(height: 1),
              _EnergyHistoryStat(
                label: 'Energy level vs. previous week',
                value: _comparisonValue(),
                icon: Icons.trending_down,
                iconColor: const Color(0xFF7756C8),
                iconBackground: const Color(0xFFEDE7FA),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                key: const ValueKey('toggle-energy-history-summary'),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                label: Text(isExpanded ? 'Show less' : 'View more'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _averageValue() {
    final average = summary.averageEnergy;
    return average == null ? '-- / 5' : '${average.toStringAsFixed(1)} / 5';
  }

  String _comparisonValue() {
    final previousAverage = summary.previousAverageEnergy;
    final average = summary.averageEnergy;
    if (previousAverage == null || average == null) {
      return 'No previous week';
    }

    final change = average - previousAverage;
    if (change.abs() < 0.05) {
      return 'About the same';
    }

    final direction = change > 0 ? 'higher' : 'lower';
    return '${change.abs().toStringAsFixed(1)} $direction';
  }
}

class _EnergyHistoryStat extends StatelessWidget {
  const _EnergyHistoryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyEnergyDay extends StatelessWidget {
  const _WeeklyEnergyDay({required this.day});

  final WeeklyEnergyDay day;

  @override
  Widget build(BuildContext context) {
    final energyScore = day.energyScore;
    final mood = energyScore == null ? null : EnergyMood.fromScore(energyScore);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: energyScore == null
                ? AppColors.surfaceSoft
                : _backgroundColor(energyScore),
            borderRadius: BorderRadius.circular(11),
          ),
          child: mood == null
              ? Text(
                  '-',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Image.asset(mood.assetPath, width: 28, height: 28),
        ),
        const SizedBox(height: 8),
        Text(
          day.weekday,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Color _backgroundColor(int score) {
    return switch (score) {
      1 => const Color(0xFFFFD8CC),
      2 => const Color(0xFFF7E0DC),
      3 => const Color(0xFFCBE9EF),
      4 => const Color(0xFFD8EEF5),
      _ => const Color(0xFFE4F8C8),
    };
  }
}
