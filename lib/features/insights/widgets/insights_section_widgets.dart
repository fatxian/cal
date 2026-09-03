part of '../screens/insights_screen.dart';

class _WeeklyInsightSection extends StatelessWidget {
  const _WeeklyInsightSection({
    required this.icon,
    required this.title,
    required this.body,
    required this.isLocked,
    this.subtitle,
    this.bodyParts = const [],
    this.modelLearningProgress,
    this.personalisedModelInsight,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isLocked;
  final String? subtitle;
  final List<WeeklyInsightTextPart> bodyParts;
  final WeeklyModelLearningProgress? modelLearningProgress;
  final WeeklyPersonalisedModelInsight? personalisedModelInsight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyColor = isLocked ? AppColors.textMuted : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StandaloneCardTitle(
          title: title,
          icon: icon,
          isLocked: isLocked,
          subtitle: subtitle,
          unlockedColor:
              title == 'Cal saw a pattern this week' ||
                  personalisedModelInsight != null
              ? AppColors.ink
              : AppColors.forestGreen,
        ),
        const SizedBox(height: 18),
        if (personalisedModelInsight != null)
          _PersonalisedModelInsightContent(insight: personalisedModelInsight!)
        else if (bodyParts.isNotEmpty)
          Text.rich(
            TextSpan(
              children: [
                for (final part in bodyParts)
                  TextSpan(
                    text: part.text,
                    style: TextStyle(
                      fontWeight: part.isEmphasised
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
              ],
            ),
            style: textTheme.bodyLarge?.copyWith(
              color: isLocked ? AppColors.textMuted : AppColors.ink,
              height: 1.42,
            ),
          )
        else
          Text(
            body,
            style: textTheme.bodyLarge?.copyWith(
              color: title == 'Cal saw a pattern this week' && !isLocked
                  ? AppColors.ink
                  : bodyColor,
              height: 1.42,
            ),
          ),
        if (modelLearningProgress != null) ...[
          const SizedBox(height: 16),
          Opacity(
            opacity: isLocked ? 0.62 : 1,
            child: ModelLearningProgress(
              completedSampleCount: modelLearningProgress!.completedSampleCount,
              hasLowerEnergySample: modelLearningProgress!.hasLowerEnergySample,
              hasHigherEnergySample:
                  modelLearningProgress!.hasHigherEnergySample,
            ),
          ),
        ],
      ],
    );
  }
}

class _PersonalisedModelInsightContent extends StatelessWidget {
  const _PersonalisedModelInsightContent({required this.insight});

  final WeeklyPersonalisedModelInsight insight;

  @override
  Widget build(BuildContext context) {
    final signals = [
      if (insight.lowerEnergySignal != null)
        (signal: insight.lowerEnergySignal!, isLowerEnergy: true),
      if (insight.higherEnergySignal != null)
        (signal: insight.higherEnergySignal!, isLowerEnergy: false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (signals.isEmpty)
          Text(
            'Cal does not have a clear direction to show yet.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.42,
            ),
          )
        else
          for (var index = 0; index < signals.length; index++) ...[
            if (index > 0) ...[
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 18),
            ],
            _ModelSignalRow(
              signal: signals[index].signal,
              isLowerEnergy: signals[index].isLowerEnergy,
            ),
          ],
      ],
    );
  }
}

class _ModelSignalRow extends StatelessWidget {
  const _ModelSignalRow({required this.signal, required this.isLowerEnergy});

  final WeeklyModelSignal signal;
  final bool isLowerEnergy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InsightContentIcon(
          icon: isLowerEnergy ? Icons.arrow_downward : Icons.arrow_upward,
          color: isLowerEnergy ? AppColors.error : AppColors.forestGreen,
          backgroundColor: isLowerEnergy
              ? AppColors.error.withValues(alpha: 0.10)
              : AppColors.forestGreen.withValues(alpha: 0.12),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signal.label,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                signal.description,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.42,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightContentIcon extends StatelessWidget {
  const _InsightContentIcon({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
