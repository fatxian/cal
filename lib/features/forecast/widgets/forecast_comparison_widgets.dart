part of '../screens/forecast_screen.dart';

class _ForecastComparison extends StatelessWidget {
  const _ForecastComparison({
    super.key,
    required this.supportiveFactor,
    required this.demandingFactor,
    required this.supportiveModelFactors,
    required this.demandingModelFactors,
    required this.modelExplanation,
    required this.comparisonMessage,
    required this.selectedResponse,
    required this.isSavingResponse,
    required this.onResponseSelected,
    required this.onEditReflection,
  });

  final ForecastFactorOption supportiveFactor;
  final ForecastFactorOption demandingFactor;
  final List<String> supportiveModelFactors;
  final List<String> demandingModelFactors;
  final String? modelExplanation;
  final String comparisonMessage;
  final int? selectedResponse;
  final bool isSavingResponse;
  final ValueChanged<int> onResponseSelected;
  final VoidCallback onEditReflection;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Compare your view with Cal',
                style: textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            TextButton(onPressed: onEditReflection, child: const Text('Edit')),
          ],
        ),
        const SizedBox(height: 14),
        _ComparisonSection(
          icon: Icons.arrow_upward,
          iconColor: AppColors.forestGreen,
          title: 'Increase your energy',
          userFactor: supportiveFactor.label,
          modelFactors: supportiveModelFactors,
          emptyModelMessage:
              'Cal did not identify a calendar signal that may increase your energy today.',
        ),
        const SizedBox(height: 18),
        _ComparisonSection(
          icon: Icons.arrow_downward,
          iconColor: AppColors.error,
          title: 'Decrease your energy',
          userFactor: demandingFactor.label,
          modelFactors: demandingModelFactors,
          emptyModelMessage:
              'Cal did not identify a calendar signal that may decrease your energy today.',
        ),
        if (modelExplanation != null) ...[
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      size: 20,
                      color: AppColors.ink,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Why Cal saw today this way',
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _HighlightedModelExplanation(text: modelExplanation!),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            comparisonMessage,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(height: 36),
        Text(
          'Does Cal’s view match what you expect today?',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 16) / 3;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ResponseButton(
                  width: buttonWidth,
                  label: 'Not really',
                  icon: Icons.sentiment_dissatisfied_outlined,
                  isSelected: selectedResponse == 0,
                  onTap: isSavingResponse ? null : () => onResponseSelected(0),
                ),
                _ResponseButton(
                  width: buttonWidth,
                  label: 'Partly',
                  icon: Icons.sentiment_neutral_outlined,
                  isSelected: selectedResponse == 1,
                  onTap: isSavingResponse ? null : () => onResponseSelected(1),
                ),
                _ResponseButton(
                  width: buttonWidth,
                  label: 'Yes',
                  icon: Icons.sentiment_satisfied_alt_outlined,
                  isSelected: selectedResponse == 2,
                  onTap: isSavingResponse ? null : () => onResponseSelected(2),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.userFactor,
    required this.modelFactors,
    required this.emptyModelMessage,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String userFactor;
  final List<String> modelFactors;
  final String emptyModelMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You: $userFactor',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            modelFactors.isEmpty
                ? emptyModelMessage
                : 'Cal: ${modelFactors.join(', ')}',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightedModelExplanation extends StatelessWidget {
  const _HighlightedModelExplanation({required this.text});

  final String text;

  static final RegExp _highlightPattern = RegExp(
    r'\d+(?:\.\d+)? (?:minutes?|hours?)|'
    r'\d+ back-to-back transitions?|'
    r'long gaps between activities|'
    r'longest stretch without a break|'
    r'planned activities|focused activities|social activities|'
    r'life admin tasks|exercise|lower energy|higher energy',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: AppColors.ink, height: 1.42);
    final spans = <TextSpan>[];
    var offset = 0;

    for (final match in _highlightPattern.allMatches(text)) {
      if (match.start > offset) {
        spans.add(TextSpan(text: text.substring(offset, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
      offset = match.end;
    }
    if (offset < text.length) {
      spans.add(TextSpan(text: text.substring(offset)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
