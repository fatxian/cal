part of '../screens/insights_screen.dart';

class _WeeklyInsightCards extends StatelessWidget {
  const _WeeklyInsightCards({
    required this.sections,
    required this.intentionSummaries,
  });

  final List<WeeklyInsightSection> sections;
  final List<WeeklyIntentionInsight> intentionSummaries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          if (index > 0) const SizedBox(height: 18),
          if (sections[index].title == 'Your intentions')
            _IntentionInsightCard(
              summaries: intentionSummaries,
              isLocked: sections[index].isLocked,
              lockedMessage: sections[index].body,
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _WeeklyInsightSection(
                  icon: _iconForSection(sections[index]),
                  title: sections[index].title,
                  body: sections[index].body,
                  isLocked: sections[index].isLocked,
                  subtitle: sections[index].subtitle,
                  bodyParts: sections[index].bodyParts,
                  modelLearningProgress: sections[index].modelLearningProgress,
                  personalisedModelInsight:
                      sections[index].personalisedModelInsight,
                ),
              ),
            ),
        ],
      ],
    );
  }

  IconData _iconForSection(WeeklyInsightSection section) {
    return switch (section.title) {
      'Cal saw a pattern this week' => Icons.insights_outlined,
      'Your intentions' => Icons.flag_outlined,
      'What Cal has learned over time' => Icons.model_training_outlined,
      _ => Icons.favorite_border,
    };
  }
}

class _IntentionInsightCard extends StatefulWidget {
  const _IntentionInsightCard({
    required this.summaries,
    required this.isLocked,
    required this.lockedMessage,
  });

  final List<WeeklyIntentionInsight> summaries;
  final bool isLocked;
  final String lockedMessage;

  @override
  State<_IntentionInsightCard> createState() => _IntentionInsightCardState();
}

class _IntentionInsightCardState extends State<_IntentionInsightCard> {
  bool isExpanded = false;

  @override
  void didUpdateWidget(covariant _IntentionInsightCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.summaries != widget.summaries) isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visibleSummaries = isExpanded
        ? widget.summaries
        : widget.summaries.take(1);

    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          widget.summaries.length > 1 ? 12 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StandaloneCardTitle(
              title: 'What you tried',
              icon: Icons.flag_outlined,
              isLocked: widget.isLocked,
              subtitle: 'Based on intentions and Daily Reflection responses',
            ),
            const SizedBox(height: 20),
            if (widget.isLocked)
              Text(
                widget.lockedMessage,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.42,
                ),
              )
            else
              for (var index = 0; index < visibleSummaries.length; index++) ...[
                if (index > 0) ...[
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                ],
                _IntentionInsightRow(
                  summary: visibleSummaries.elementAt(index),
                ),
              ],
            if (widget.summaries.length > 1) ...[
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
                  label: Text(isExpanded ? 'Show less' : 'View all intentions'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IntentionInsightRow extends StatelessWidget {
  const _IntentionInsightRow({required this.summary});

  final WeeklyIntentionInsight summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _InsightContentIcon(
              icon: _icon(),
              color: _iconColor(),
              backgroundColor: _iconBackgroundColor(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                summary.label,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${summary.setCount} ${summary.setCount == 1 ? 'time' : 'times'}',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _IntentionStat(
              icon: Icons.check,
              label: '${summary.completedCount} completed',
              color: AppColors.forestGreen,
              backgroundColor: const Color(0xFFE5F2E8),
            ),
            if (summary.increasedCount > 0)
              _IntentionStat(
                icon: Icons.arrow_upward,
                label: _energyCountText('increase', summary.increasedCount),
                color: AppColors.forestGreen,
                backgroundColor: const Color(0xFFE5F2E8),
              ),
            if (summary.unchangedCount > 0)
              _IntentionStat(
                icon: Icons.remove,
                label: _noChangeCountText(summary.unchangedCount),
                color: AppColors.textSecondary,
                backgroundColor: const Color(0xFFF4EFE3),
              ),
            if (summary.decreasedCount > 0)
              _IntentionStat(
                icon: Icons.arrow_downward,
                label: _energyCountText('decrease', summary.decreasedCount),
                color: AppColors.error,
                backgroundColor: const Color(0xFFF8E5E5),
              ),
          ],
        ),
      ],
    );
  }

  String _energyCountText(String direction, int count) {
    return '$count energy $direction${count == 1 ? '' : 's'}';
  }

  String _noChangeCountText(int count) {
    return '$count no energy change${count == 1 ? '' : 's'}';
  }

  IconData _icon() {
    return switch (summary.adjustmentType) {
      'shortWalk' => Icons.directions_walk,
      'stretch' => Icons.accessibility_new,
      'protectBreak' ||
      'keepTimeFree' ||
      'screenBreak' ||
      'quietPause' => Icons.self_improvement,
      'focusSession' => Icons.center_focus_strong,
      'socialMoment' => Icons.chat_bubble_outline,
      'lifeAdminTask' => Icons.checklist_outlined,
      'leaveBuffer' => Icons.space_bar,
      'keepPlan' => Icons.event_available_outlined,
      _ => Icons.lightbulb_outline,
    };
  }

  Color _iconColor() {
    return switch (summary.adjustmentType) {
      'shortWalk' || 'stretch' => AppColors.forestGreen,
      'protectBreak' ||
      'keepTimeFree' ||
      'screenBreak' ||
      'quietPause' => const Color(0xFF7756C8),
      'focusSession' => const Color(0xFFB88400),
      'socialMoment' => const Color(0xFF3978B8),
      'lifeAdminTask' => const Color(0xFFC56F44),
      'leaveBuffer' => AppColors.error,
      'keepPlan' => AppColors.forestGreen,
      _ => AppColors.textSecondary,
    };
  }

  Color _iconBackgroundColor() {
    return switch (summary.adjustmentType) {
      'shortWalk' || 'stretch' => AppColors.mintTag,
      'protectBreak' ||
      'keepTimeFree' ||
      'screenBreak' ||
      'quietPause' => AppColors.lavender,
      'focusSession' => AppColors.sunshine.withValues(alpha: 0.52),
      'socialMoment' => AppColors.skyBlue,
      'lifeAdminTask' => AppColors.peach,
      'leaveBuffer' => AppColors.blushPink,
      'keepPlan' => const Color(0xFFEAF3DF),
      _ => AppColors.surfaceSoft,
    };
  }
}

class _IntentionStat extends StatelessWidget {
  const _IntentionStat({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
