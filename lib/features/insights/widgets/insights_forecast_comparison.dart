part of '../screens/insights_screen.dart';

class _ForecastComparisonCard extends StatelessWidget {
  const _ForecastComparisonCard({required this.comparison});

  final WeeklyForecastComparison comparison;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasComparisons = comparison.comparedDayCount > 0;
    final summaryBlocks = _summaryBlocks();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StandaloneCardTitle(
              title: 'You & Cal',
              icon: Icons.compare_arrows,
              isLocked: !hasComparisons,
              subtitle:
                  'Based on your Reveal and reflect responses in Forecast',
            ),
            const SizedBox(height: 20),
            if (!hasComparisons)
              Text(
                'Complete Reveal and reflect from Today to unlock a '
                'comparison of your expectations and Cal’s view.',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.42,
                ),
              )
            else
              ...summaryBlocks.indexed.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(top: entry.$1 == 0 ? 0 : 20),
                  child: _ForecastComparisonSummaryBlock(
                    heading: entry.$2.heading,
                    icon: entry.$2.icon,
                    color: entry.$2.color,
                    bodyParts: entry.$2.bodyParts,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<
    ({
      String heading,
      IconData icon,
      Color color,
      List<WeeklyInsightTextPart> bodyParts,
    })
  >
  _summaryBlocks() {
    final dayLabel = comparison.comparedDayCount == 1 ? 'day' : 'days';
    final blocks =
        <
          ({
            String heading,
            IconData icon,
            Color color,
            List<WeeklyInsightTextPart> bodyParts,
          })
        >[];
    final difference = comparison.biggestDifference;

    if (difference != null) {
      blocks.add((
        heading: 'A different perspective',
        icon: Icons.lightbulb_outline,
        color: const Color(0xFFC39200),
        bodyParts: [
          const WeeklyInsightTextPart('You expected '),
          WeeklyInsightTextPart(
            _sentenceLabel(difference.userFactor),
            isEmphasised: true,
          ),
          WeeklyInsightTextPart(
            ' to ${_effectVerb(difference.userEffect)} your energy',
          ),
          const WeeklyInsightTextPart(', while Cal more often highlighted '),
          WeeklyInsightTextPart(
            _sentenceLabel(difference.modelFactor),
            isEmphasised: true,
          ),
          const WeeklyInsightTextPart('.'),
        ],
      ));
    }

    if (comparison.mostFrequentSharedFactor != null &&
        comparison.sharedFactorEffect != null) {
      blocks.add((
        heading: 'A shared perspective',
        icon: Icons.check,
        color: AppColors.forestGreen,
        bodyParts: [
          const WeeklyInsightTextPart('You and Cal both highlighted '),
          WeeklyInsightTextPart(
            _sentenceLabel(comparison.mostFrequentSharedFactor!),
            isEmphasised: true,
          ),
          WeeklyInsightTextPart(
            comparison.sharedFactorEffect == WeeklyForecastFactorEffect.increase
                ? ' as something that could increase your energy.'
                : ' as something that could decrease your energy.',
          ),
        ],
      ));
    }

    if (blocks.isEmpty) {
      blocks.add((
        heading: 'Your weekly comparison',
        icon: Icons.compare_arrows,
        color: AppColors.textSecondary,
        bodyParts: [
          const WeeklyInsightTextPart(
            'Your view matched or partly matched Cal on ',
          ),
          WeeklyInsightTextPart(
            '${comparison.similarDayCount} of '
            '${comparison.comparedDayCount} $dayLabel',
            isEmphasised: true,
          ),
          const WeeklyInsightTextPart('.'),
        ],
      ));
    }

    return blocks;
  }

  String _effectVerb(WeeklyForecastFactorEffect effect) {
    return effect == WeeklyForecastFactorEffect.increase
        ? 'increase'
        : 'decrease';
  }

  String _sentenceLabel(String label) {
    if (label.isEmpty) return label;
    return '${label[0].toLowerCase()}${label.substring(1)}';
  }
}

class _ForecastComparisonSummaryBlock extends StatelessWidget {
  const _ForecastComparisonSummaryBlock({
    required this.heading,
    required this.icon,
    required this.color,
    required this.bodyParts,
  });

  final String heading;
  final IconData icon;
  final Color color;
  final List<WeeklyInsightTextPart> bodyParts;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                heading,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
            color: AppColors.ink,
            height: 1.42,
          ),
        ),
      ],
    );
  }
}
