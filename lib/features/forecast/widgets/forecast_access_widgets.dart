part of '../screens/forecast_screen.dart';

class _ForecastLoadErrorCard extends StatelessWidget {
  const _ForecastLoadErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class _ForecastWaitingPreview extends StatelessWidget {
  const _ForecastWaitingPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 196,
          height: 196,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.forestGreen.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.question_mark,
            size: 72,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Today\'s forecast is waiting',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.forestGreen),
        ),
      ],
    );
  }
}

class _ForecastAccessCard extends StatelessWidget {
  const _ForecastAccessCard({
    required this.hasCalendarInput,
    required this.uncategorizedEventCount,
    required this.onOpenToday,
  });

  final bool hasCalendarInput;
  final int uncategorizedEventCount;
  final VoidCallback onOpenToday;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final needsCategories = hasCalendarInput && uncategorizedEventCount > 0;
    final activityText = uncategorizedEventCount == 1
        ? '1 activity still needs a category.'
        : '$uncategorizedEventCount activities still need categories.';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              needsCategories
                  ? 'Categorise today\'s activities'
                  : 'Add or sync today\'s activities',
              style: textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              needsCategories
                  ? '$activityText Choose a category or Not sure for every '
                        'activity before viewing today\'s forecast.'
                  : 'Add an activity in Today, or pull down to sync Google '
                        'Calendar before revealing today\'s forecast.',
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
}
