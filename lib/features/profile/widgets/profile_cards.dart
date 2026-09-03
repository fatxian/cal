import 'package:flutter/material.dart';

import '../../../core/notifications/daily_notification_preferences.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingSetupCard extends StatelessWidget {
  const OnboardingSetupCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.mintTag,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tune, color: AppColors.forestGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onboarding questionnaire setup',
                      style: textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View or edit your onboarding answers',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationSettingsCard extends StatelessWidget {
  const NotificationSettingsCard({
    super.key,
    required this.preferences,
    required this.isLoading,
    required this.isUpdating,
    required this.onMorningEnabledChanged,
    required this.onEveningEnabledChanged,
    required this.onMorningTimeTap,
    required this.onEveningTimeTap,
  });

  final DailyNotificationPreferences preferences;
  final bool isLoading;
  final bool isUpdating;
  final ValueChanged<bool> onMorningEnabledChanged;
  final ValueChanged<bool> onEveningEnabledChanged;
  final VoidCallback onMorningTimeTap;
  final VoidCallback onEveningTimeTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.skyBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Notifications',
                  style: textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (isLoading)
              const LinearProgressIndicator()
            else ...[
              NotificationSettingRow(
                title: 'Morning forecast reminder',
                description:
                    "Review today's schedule and reveal your forecast.",
                enabled: preferences.morningEnabled,
                time: TimeOfDay(
                  hour: preferences.morningHour,
                  minute: preferences.morningMinute,
                ),
                isUpdating: isUpdating,
                onEnabledChanged: onMorningEnabledChanged,
                onTimeTap: onMorningTimeTap,
              ),
              const Divider(height: 30),
              NotificationSettingRow(
                title: 'Evening reflection reminder',
                description: 'How did today feel? Add your daily reflection.',
                enabled: preferences.eveningEnabled,
                time: TimeOfDay(
                  hour: preferences.eveningHour,
                  minute: preferences.eveningMinute,
                ),
                isUpdating: isUpdating,
                onEnabledChanged: onEveningEnabledChanged,
                onTimeTap: onEveningTimeTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NotificationSettingRow extends StatelessWidget {
  const NotificationSettingRow({
    super.key,
    required this.title,
    required this.description,
    required this.enabled,
    required this.time,
    required this.isUpdating,
    required this.onEnabledChanged,
    required this.onTimeTap,
  });

  final String title;
  final String description;
  final bool enabled;
  final TimeOfDay time;
  final bool isUpdating;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedTime = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(time);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(description, style: textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(
              value: enabled,
              onChanged: isUpdating ? null : onEnabledChanged,
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: isUpdating ? null : onTimeTap,
          icon: const Icon(Icons.schedule, size: 19),
          label: Text(formattedTime),
        ),
      ],
    );
  }
}

class ResearchDataExportCard extends StatelessWidget {
  const ResearchDataExportCard({
    super.key,
    required this.isExporting,
    required this.onExport,
  });

  final bool isExporting;
  final ValueChanged<BuildContext> onExport;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.lavender,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ios_share_outlined,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Export research data',
                    style: textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Create a de-identified JSON file from your saved Cal data. '
              'Calendar titles and account details are not included.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Builder(
              builder: (buttonContext) => FilledButton(
                onPressed: isExporting ? null : () => onExport(buttonContext),
                child: isExporting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Export JSON'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DebugPredictionDataCard extends StatelessWidget {
  const DebugPredictionDataCard({
    super.key,
    required this.isLoading,
    required this.onGenerate,
    required this.onClear,
  });

  final bool isLoading;
  final VoidCallback onGenerate;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Developer tools',
              style: textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: isLoading ? null : onGenerate,
              child: const Text('Generate Cal test data'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: isLoading ? null : onClear,
              child: const Text('Clear generated test data'),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleCalendarConnectionCard extends StatelessWidget {
  const GoogleCalendarConnectionCard({
    super.key,
    required this.isLoading,
    required this.isConnected,
    required this.shouldReconnect,
    required this.statusMessage,
    required this.errorMessage,
    required this.onConnect,
    required this.onSignOut,
  });

  final bool isLoading;
  final bool isConnected;
  final bool shouldReconnect;
  final String statusMessage;
  final String? errorMessage;
  final VoidCallback onConnect;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect to Google Calendar',
              style: textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            if (!isConnected || shouldReconnect) ...[
              const SizedBox(height: 12),
              Text(
                shouldReconnect
                    ? 'Google Calendar needs to be reconnected.'
                    : statusMessage,
                style: textTheme.bodyMedium,
              ),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: 14),
              Text(
                errorMessage!,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: isLoading ? null : onConnect,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      shouldReconnect
                          ? 'Reconnect Google Calendar'
                          : 'Connect Google Calendar',
                    ),
            ),
            if (isConnected && !shouldReconnect) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: isLoading ? null : onSignOut,
                child: const Text('Sign out'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
