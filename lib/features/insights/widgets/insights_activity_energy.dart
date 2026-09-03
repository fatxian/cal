part of '../screens/insights_screen.dart';

class _ActivityEnergyCard extends StatefulWidget {
  const _ActivityEnergyCard({required this.summaries});

  final List<WeeklyActivityEnergySummary> summaries;

  @override
  State<_ActivityEnergyCard> createState() => _ActivityEnergyCardState();
}

class _ActivityEnergyCardState extends State<_ActivityEnergyCard> {
  bool isExpanded = false;

  @override
  void didUpdateWidget(covariant _ActivityEnergyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.summaries != widget.summaries) isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final summaries = widget.summaries;
    final isLocked = summaries.isEmpty;
    final visibleSummaries = isExpanded ? summaries : summaries.take(1);

    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          summaries.length > 1 ? 12 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StandaloneCardTitle(
              title: 'Activities & Energy',
              icon: Icons.event_note_outlined,
              isLocked: isLocked,
              subtitle: 'Based on category and energy responses from Today',
            ),
            const SizedBox(height: 22),
            if (isLocked)
              Text(
                'Add a category and energy response to a completed activity '
                'to unlock your activity patterns.',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.42,
                ),
              )
            else
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < visibleSummaries.length;
                      index++
                    ) ...[
                      if (index > 0) ...[
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                      ],
                      _ActivityEnergyRow(
                        summary: visibleSummaries.elementAt(index),
                      ),
                    ],
                  ],
                ),
              ),
            if (summaries.length > 1) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(isExpanded ? 'Show less' : 'View all activities'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StandaloneCardTitle extends StatelessWidget {
  const _StandaloneCardTitle({
    required this.title,
    required this.icon,
    required this.isLocked,
    this.unlockedColor = AppColors.ink,
    this.subtitle,
  });

  final String title;
  final IconData icon;
  final bool isLocked;
  final Color unlockedColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isLocked ? AppColors.textMuted : unlockedColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _iconBackgroundColor().withValues(
              alpha: isLocked ? 0.48 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        color: color,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  if (isLocked) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.lock_outline, color: color, size: 20),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5),
                Text(
                  subtitle!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isLocked
                        ? AppColors.textMuted
                        : AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _iconBackgroundColor() {
    return switch (title) {
      'Cal saw a pattern this week' => AppColors.lavender,
      'Your intentions' || 'What you tried' => AppColors.peach,
      'What Cal has learned over time' => AppColors.mintTag,
      'You & Cal' => AppColors.skyBlue,
      'Activities & Energy' => AppColors.sunshine,
      'Energy history' => AppColors.blushPink,
      _ => AppColors.surfaceSoft,
    };
  }
}

class _ActivityEnergyRow extends StatelessWidget {
  const _ActivityEnergyRow({required this.summary});

  final WeeklyActivityEnergySummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final countLabel = summary.totalCount == 1
        ? '1 reflection'
        : '${summary.totalCount} reflections';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _InsightContentIcon(
              icon: _categoryIcon(),
              color: AppColors.ink,
              backgroundColor: _categoryIconBackground(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _categoryLabel(),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              countLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _EnergyImpactBar(summary: summary),
      ],
    );
  }

  String _categoryLabel() {
    return switch (summary.category) {
      'focus' => 'Focused activities',
      'social' => 'Social activities',
      'exercise' => 'Exercise activities',
      'rest' => 'Rest activities',
      'lifeAdmin' => 'Life admin activities',
      _ => 'Activity',
    };
  }

  IconData _categoryIcon() {
    return switch (summary.category) {
      'focus' => Icons.center_focus_strong,
      'social' => Icons.chat_bubble_outline,
      'exercise' => Icons.directions_run,
      'rest' => Icons.bedtime_outlined,
      'lifeAdmin' => Icons.checklist_outlined,
      _ => Icons.event_outlined,
    };
  }

  Color _categoryIconBackground() {
    return switch (summary.category) {
      'focus' => AppColors.sunshine.withValues(alpha: 0.52),
      'social' => AppColors.skyBlue,
      'exercise' => AppColors.mintTag,
      'rest' => AppColors.lavender,
      'lifeAdmin' => AppColors.peach,
      _ => AppColors.surfaceSoft,
    };
  }
}

class _EnergyImpactBar extends StatelessWidget {
  const _EnergyImpactBar({required this.summary});

  static const decreasedColor = Color(0xFFF1BFC7);
  static const unchangedColor = Color(0xFFD8DFEA);
  static const increasedColor = Color(0xFFBFE2C8);

  final WeeklyActivityEnergySummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label:
              '${_percentage(summary.decreasedCount)} percent decreased, '
              '${_percentage(summary.unchangedCount)} percent no change, '
              '${_percentage(summary.increasedCount)} percent increased',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (summary.decreasedCount > 0)
                    Expanded(
                      flex: summary.decreasedCount,
                      child: const ColoredBox(color: decreasedColor),
                    ),
                  if (summary.unchangedCount > 0)
                    Expanded(
                      flex: summary.unchangedCount,
                      child: const ColoredBox(color: unchangedColor),
                    ),
                  if (summary.increasedCount > 0)
                    Expanded(
                      flex: summary.increasedCount,
                      child: const ColoredBox(color: increasedColor),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _EnergyImpactLegend(
              color: decreasedColor,
              label: 'Decreased',
              percentage: _percentage(summary.decreasedCount),
            ),
            _EnergyImpactLegend(
              color: unchangedColor,
              label: 'No change',
              percentage: _percentage(summary.unchangedCount),
            ),
            _EnergyImpactLegend(
              color: increasedColor,
              label: 'Increased',
              percentage: _percentage(summary.increasedCount),
            ),
          ],
        ),
      ],
    );
  }

  int _percentage(int count) => (count / summary.totalCount * 100).round();
}

class _EnergyImpactLegend extends StatelessWidget {
  const _EnergyImpactLegend({
    required this.color,
    required this.label,
    required this.percentage,
  });

  final Color color;
  final String label;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $percentage%',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
