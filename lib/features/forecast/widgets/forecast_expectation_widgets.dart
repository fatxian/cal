part of '../screens/forecast_screen.dart';

class _ForecastExpectationFlow extends StatelessWidget {
  const _ForecastExpectationFlow({
    super.key,
    required this.isLoading,
    required this.factorOptions,
    required this.selectedSupportiveFactor,
    required this.selectedDemandingFactor,
    required this.hasStarted,
    required this.isSaving,
    required this.onSupportiveFactorSelected,
    required this.onDemandingFactorSelected,
    required this.onStart,
    required this.onReveal,
  });

  final bool isLoading;
  final List<ForecastFactorOption> factorOptions;
  final ForecastFactorOption? selectedSupportiveFactor;
  final ForecastFactorOption? selectedDemandingFactor;
  final bool hasStarted;
  final bool isSaving;
  final ValueChanged<ForecastFactorOption> onSupportiveFactorSelected;
  final ValueChanged<ForecastFactorOption> onDemandingFactorSelected;
  final VoidCallback onStart;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Curious what Cal noticed?',
          style: textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          'First, take a quick look at your schedule and make your own guess. '
          'Then reveal how Cal sees today.',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: hasStarted
              ? _ForecastQuestions(
                  isLoading: isLoading,
                  factorOptions: factorOptions,
                  selectedSupportiveFactor: selectedSupportiveFactor,
                  selectedDemandingFactor: selectedDemandingFactor,
                  isSaving: isSaving,
                  onSupportiveFactorSelected: onSupportiveFactorSelected,
                  onDemandingFactorSelected: onDemandingFactorSelected,
                  onReveal: onReveal,
                )
              : SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onStart,
                    child: const Text('Reveal and reflect'),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ForecastQuestions extends StatelessWidget {
  const _ForecastQuestions({
    required this.isLoading,
    required this.factorOptions,
    required this.selectedSupportiveFactor,
    required this.selectedDemandingFactor,
    required this.isSaving,
    required this.onSupportiveFactorSelected,
    required this.onDemandingFactorSelected,
    required this.onReveal,
  });

  final bool isLoading;
  final List<ForecastFactorOption> factorOptions;
  final ForecastFactorOption? selectedSupportiveFactor;
  final ForecastFactorOption? selectedDemandingFactor;
  final bool isSaving;
  final ValueChanged<ForecastFactorOption> onSupportiveFactorSelected;
  final ValueChanged<ForecastFactorOption> onDemandingFactorSelected;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Which part of today’s schedule do you think will increase your energy?',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ForecastFactorDropdown(
          key: const ValueKey('supportive-factor-dropdown'),
          options: factorOptions,
          selectedOption: selectedSupportiveFactor,
          onSelected: onSupportiveFactorSelected,
        ),
        const SizedBox(height: 26),
        Text(
          'Which part of today’s schedule do you think will decrease your energy?',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ForecastFactorDropdown(
          key: const ValueKey('demanding-factor-dropdown'),
          options: factorOptions,
          selectedOption: selectedDemandingFactor,
          onSelected: onDemandingFactorSelected,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed:
                selectedSupportiveFactor == null ||
                    selectedDemandingFactor == null ||
                    isSaving
                ? null
                : onReveal,
            child: Text(isSaving ? 'Saving reflection...' : 'Compare with Cal'),
          ),
        ),
      ],
    );
  }
}
