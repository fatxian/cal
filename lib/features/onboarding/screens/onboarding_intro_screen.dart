import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OnboardingIntroScreen extends StatefulWidget {
  const OnboardingIntroScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  State<OnboardingIntroScreen> createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends State<OnboardingIntroScreen> {
  var isQuestionnaireIntroductionVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isQuestionnaireIntroductionVisible
              ? _QuestionnaireIntroduction(
                  key: const ValueKey('questionnaire-introduction'),
                  onStart: widget.onStart,
                )
              : _CalIntroduction(
                  key: const ValueKey('cal-introduction'),
                  onContinue: () {
                    setState(() {
                      isQuestionnaireIntroductionVisible = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}

class _CalIntroduction extends StatelessWidget {
  const _CalIntroduction({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _IntroductionLayout(
      icon: Icons.energy_savings_leaf_outlined,
      title: 'Meet Cal',
      subtitle: 'Your personal energy reflection companion.',
      paragraphs: const [
        'Cal helps you notice how your schedule and energy may relate. '
            'Compare your expectations with Cal’s daily forecast, choose a '
            'small intention, and reflect on how your day felt.',
        'Cal does not decide how you should feel. It offers another '
            'perspective to help you understand your own patterns.',
      ],
      primaryButtonLabel: 'Continue',
      onPrimaryPressed: onContinue,
    );
  }
}

class _QuestionnaireIntroduction extends StatelessWidget {
  const _QuestionnaireIntroduction({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return _IntroductionLayout(
      icon: Icons.tune,
      title: 'Help Cal get to know you',
      paragraphs: const [
        'Start with a few short questions about how different schedules and '
            'activities usually affect your energy.',
        'Your answers will provide a starting point for Cal’s forecasts. '
            'After enough daily reflections, Cal can build a personalised '
            'model based on your own patterns.',
      ],
      detail: '11 questions · About 2 minutes',
      footer: 'There are no right or wrong answers.',
      primaryButtonLabel: 'Start questionnaire',
      onPrimaryPressed: onStart,
    );
  }
}

class _IntroductionLayout extends StatelessWidget {
  const _IntroductionLayout({
    required this.icon,
    required this.title,
    required this.paragraphs,
    required this.primaryButtonLabel,
    required this.onPrimaryPressed,
    this.subtitle,
    this.detail,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String> paragraphs;
  final String? detail;
  final String? footer;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    color: AppColors.mintTag,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 52, color: AppColors.forestGreen),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                ],
                for (final paragraph in paragraphs) ...[
                  const SizedBox(height: 16),
                  Text(
                    paragraph,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (detail != null) ...[
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(detail!, style: textTheme.labelLarge),
                  ),
                ],
                const Spacer(),
                if (footer != null) ...[
                  Text(
                    footer!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton(
                  onPressed: onPrimaryPressed,
                  child: Text(primaryButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
