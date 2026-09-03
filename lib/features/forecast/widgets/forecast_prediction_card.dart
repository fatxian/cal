part of '../screens/forecast_screen.dart';

class _PredictionOverview extends StatelessWidget {
  const _PredictionOverview({required this.prediction});

  final DailyPrediction prediction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LowEnergyLikelihoodGauge(
          lowEnergyLikelihood: prediction.predictedScore,
        ),
      ],
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({
    required this.prediction,
    required this.isLoading,
    required this.errorMessage,
    required this.selectedResponse,
    required this.isSavingResponse,
    required this.isLoadingFactors,
    required this.factorOptions,
    required this.selectedSupportiveFactor,
    required this.selectedDemandingFactor,
    required this.supportiveModelFactors,
    required this.demandingModelFactors,
    required this.modelExplanation,
    required this.isReflectionRevealed,
    required this.hasStartedReflection,
    required this.isSavingReflection,
    required this.onRetry,
    required this.onOpenToday,
    required this.onResponseSelected,
    required this.onSupportiveFactorSelected,
    required this.onDemandingFactorSelected,
    required this.onReveal,
    required this.onStartReflection,
    required this.onEditReflection,
    required this.comparisonMessage,
  });

  final DailyPrediction? prediction;
  final bool isLoading;
  final String? errorMessage;
  final int? selectedResponse;
  final bool isSavingResponse;
  final bool isLoadingFactors;
  final List<ForecastFactorOption> factorOptions;
  final ForecastFactorOption? selectedSupportiveFactor;
  final ForecastFactorOption? selectedDemandingFactor;
  final List<String> supportiveModelFactors;
  final List<String> demandingModelFactors;
  final String? modelExplanation;
  final bool isReflectionRevealed;
  final bool hasStartedReflection;
  final bool isSavingReflection;
  final VoidCallback onRetry;
  final VoidCallback onOpenToday;
  final ValueChanged<int> onResponseSelected;
  final ValueChanged<ForecastFactorOption> onSupportiveFactorSelected;
  final ValueChanged<ForecastFactorOption> onDemandingFactorSelected;
  final VoidCallback onReveal;
  final VoidCallback onStartReflection;
  final VoidCallback onEditReflection;
  final String? comparisonMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorMessage!, style: textTheme.bodyLarge),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Try again'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onOpenToday,
                child: const Text('Go to Today'),
              ),
            ],
          ),
        ),
      );
    }

    // if today's prediction hasn't unlocked yet, show text to let user go to Today tab
    final currentPrediction = prediction;
    if (currentPrediction == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reveal today\'s forecast',
                style: textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Review today\'s calendar, then use the forecast card in Today '
                'to reveal your prediction.',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onOpenToday,
                child: const Text('Go to Today'),
              ),
            ],
          ),
        ),
      );
    }

    final isLowEnergy =
        currentPrediction.predictedCategory == DailyPredictionCategory.low;
    final modelSourceText = _modelSourceText(currentPrediction);
    final imagePath = _predictionImagePathForScore(
      currentPrediction.predictedScore,
    );

    return Column(
      children: [
        Card(
          color: const Color(0xFFEAF5FA),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 88,
                  height: 88,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLowEnergy
                            ? 'Lower energy may be more likely today.'
                            : 'Your energy may feel more manageable today.',
                        style: textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        modelSourceText,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: isReflectionRevealed
                  ? _ForecastComparison(
                      key: const ValueKey('forecast-comparison'),
                      supportiveFactor: selectedSupportiveFactor!,
                      demandingFactor: selectedDemandingFactor!,
                      supportiveModelFactors: supportiveModelFactors,
                      demandingModelFactors: demandingModelFactors,
                      modelExplanation: modelExplanation,
                      comparisonMessage: comparisonMessage!,
                      selectedResponse: selectedResponse,
                      isSavingResponse: isSavingResponse,
                      onResponseSelected: onResponseSelected,
                      onEditReflection: onEditReflection,
                    )
                  : _ForecastExpectationFlow(
                      key: const ValueKey('forecast-expectation'),
                      isLoading: isLoadingFactors,
                      factorOptions: factorOptions,
                      selectedSupportiveFactor: selectedSupportiveFactor,
                      selectedDemandingFactor: selectedDemandingFactor,
                      hasStarted: hasStartedReflection,
                      isSaving: isSavingReflection,
                      onSupportiveFactorSelected: onSupportiveFactorSelected,
                      onDemandingFactorSelected: onDemandingFactorSelected,
                      onStart: onStartReflection,
                      onReveal: onReveal,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String _modelSourceText(DailyPrediction prediction) {
    if (prediction.predictionVersion.startsWith('questionnaire-baseline')) {
      return 'Based on your initial questionnaire. Cal is still learning '
          'from your reflections.';
    }

    if (prediction.predictionVersion.startsWith('personalised')) {
      return 'Based on patterns Cal learned from your reflections.';
    }

    return 'Based on your schedule.';
  }
}
