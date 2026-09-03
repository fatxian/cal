import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/energy_mood.dart';
import '../../../shared/widgets/energy_scale_selector.dart';
import '../../calendar/models/calendar_event.dart';
import '../../calendar/models/calendar_event_category.dart';
import '../../calendar/models/event_energy_impact.dart';
import '../../calendar/widgets/event_category_selector.dart';
import '../../calendar/widgets/event_energy_impact_selector.dart';
import '../models/daily_reflection.dart';
import '../../forecast/models/daily_intention.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({
    super.key,
    required this.day,
    this.initialReflection,
    this.intention,
    this.events = const [],
    this.onEventUpdated,
  });

  final DateTime day;
  final DailyReflection? initialReflection;
  final DailyIntention? intention;
  final List<CalendarEvent> events;
  final Future<void> Function(CalendarEvent event)? onEventUpdated;

  @override
  State<DailyReflectionScreen> createState() => _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  late int selectedEnergyScore;
  int? selectedCompletionScore;
  int? selectedHelpfulnessScore;
  late List<CalendarEvent> reviewableEvents;
  bool isReviewingActivities = false;
  bool activityReminderDismissed = false;

  @override
  void initState() {
    super.initState();
    selectedEnergyScore = widget.initialReflection?.energyScore ?? 3;
    selectedCompletionScore =
        widget.initialReflection?.intentionCompletionScore;
    selectedHelpfulnessScore =
        widget.initialReflection?.intentionHelpfulnessScore;
    reviewableEvents = widget.events
        .where((event) => !event.endTime.isAfter(DateTime.now()))
        .toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mood = EnergyMood.fromScore(selectedEnergyScore);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 120),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30),
                  color: AppColors.ink,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 18),
                Text('Daily Reflection', style: textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 34),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  _formatDate(widget.day),
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (showActivityReminder) ...[
              const SizedBox(height: 30),
              _ActivityReviewPrompt(
                incompleteCount: incompleteActivityCount,
                isExpanded: isReviewingActivities,
                onReview: () {
                  setState(() {
                    isReviewingActivities = true;
                  });
                },
                onSkip: () {
                  setState(() {
                    activityReminderDismissed = true;
                    isReviewingActivities = false;
                  });
                },
              ),
              if (isReviewingActivities) ...[
                const SizedBox(height: 14),
                for (final event in incompleteActivityEvents) ...[
                  _ActivityReviewItem(
                    event: event,
                    onCategorySelected: (category) =>
                        updateEventCategory(event, category),
                    onEnergyImpactSelected: (impact) =>
                        updateEventEnergyImpact(event, impact),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ] else if (isReviewingActivities &&
                incompleteActivityCount == 0) ...[
              const SizedBox(height: 30),
              _ActivityReviewComplete(
                onDone: () {
                  setState(() {
                    isReviewingActivities = false;
                  });
                },
              ),
            ],
            const SizedBox(height: 44),
            Text(
              'How much mental energy do you have left?',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 42),
            Center(
              child: Column(
                children: [
                  Image.asset(mood.assetPath, width: 88, height: 88),
                  const SizedBox(height: 14),
                  Text(
                    mood.label,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            EnergyScaleSelector(
              selectedScore: selectedEnergyScore,
              onScoreSelected: updateEnergyScore,
            ),
            if (hasActionableIntention) ...[
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 28),
              Text(
                _plannedIntentionText(widget.intention!.adjustment.label),
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 28),
              Text('Did you manage to do it?', style: textTheme.titleMedium),
              const SizedBox(height: 14),
              _ReflectionChoiceSelector(
                labels: const ['No', 'Partly', 'Yes'],
                icons: const [
                  Icons.sentiment_dissatisfied_outlined,
                  Icons.sentiment_neutral_outlined,
                  Icons.sentiment_satisfied_alt_outlined,
                ],
                selectedScore: selectedCompletionScore,
                onSelected: updateCompletionScore,
              ),
              const SizedBox(height: 32),
              Text('Did it change your energy?', style: textTheme.titleMedium),
              const SizedBox(height: 14),
              _ReflectionChoiceSelector(
                labels: const ['Decrease', 'Not really', 'Increase'],
                icons: const [Icons.arrow_downward, null, Icons.arrow_upward],
                selectedScore: selectedHelpfulnessScore,
                onSelected: updateHelpfulnessScore,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(28, 12, 28, 28),
        child: FilledButton(
          onPressed: saveReflection,
          child: const Text('Save Reflection'),
        ),
      ),
    );
  }

  void updateEnergyScore(int score) {
    setState(() {
      selectedEnergyScore = score;
    });
  }

  // only show follow up questions when today's has an actual adjustment
  bool get hasActionableIntention {
    return widget.intention != null &&
        widget.intention!.adjustment.isActionable;
  }

  void updateCompletionScore(int score) {
    setState(() {
      selectedCompletionScore = score;
    });
  }

  void updateHelpfulnessScore(int score) {
    setState(() {
      selectedHelpfulnessScore = score;
    });
  }

  List<CalendarEvent> get incompleteActivityEvents => reviewableEvents
      .where((event) => event.category == null || event.energyImpact == null)
      .toList(growable: false);

  int get incompleteActivityCount => incompleteActivityEvents.length;

  bool get showActivityReminder =>
      !activityReminderDismissed && incompleteActivityCount > 0;

  Future<void> updateEventCategory(
    CalendarEvent event,
    CalendarEventCategory category,
  ) {
    return updateActivityEvent(event.copyWith(category: category));
  }

  Future<void> updateEventEnergyImpact(
    CalendarEvent event,
    EventEnergyImpact impact,
  ) {
    return updateActivityEvent(event.copyWith(energyImpact: impact));
  }

  Future<void> updateActivityEvent(CalendarEvent updatedEvent) async {
    setState(() {
      final index = reviewableEvents.indexWhere(
        (event) => event.id == updatedEvent.id,
      );
      if (index != -1) {
        reviewableEvents[index] = updatedEvent;
      }
    });

    await widget.onEventUpdated?.call(updatedEvent);
  }

  void saveReflection() {
    Navigator.of(context).pop(
      DailyReflection(
        energyScore: selectedEnergyScore,
        intentionCompletionScore: selectedCompletionScore,
        intentionHelpfulnessScore: selectedHelpfulnessScore,
      ),
    );
  }

  String _plannedIntentionText(String adjustment) {
    if (adjustment == 'No change today') {
      return 'You chose not to make a change today.';
    }

    final lowercaseFirstLetter =
        '${adjustment[0].toLowerCase()}${adjustment.substring(1)}';
    return 'You planned to $lowercaseFirstLetter.';
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ActivityReviewPrompt extends StatelessWidget {
  const _ActivityReviewPrompt({
    required this.incompleteCount,
    required this.isExpanded,
    required this.onReview,
    required this.onSkip,
  });

  final int incompleteCount;
  final bool isExpanded;
  final VoidCallback onReview;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activityText = incompleteCount == 1
        ? '1 completed activity is ready to reflect on.'
        : '$incompleteCount completed activities are ready to reflect on.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activityText, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Adding a category and energy response helps build your weekly insights.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (!isExpanded) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onReview,
                    child: const Text('Review activities'),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(onPressed: onSkip, child: const Text('Skip today')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivityReviewItem extends StatelessWidget {
  const _ActivityReviewItem({
    required this.event,
    required this.onCategorySelected,
    required this.onEnergyImpactSelected,
  });

  final CalendarEvent event;
  final ValueChanged<CalendarEventCategory> onCategorySelected;
  final ValueChanged<EventEnergyImpact> onEnergyImpactSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.title, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            _formatEventTime(event),
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          if (event.category == null) ...[
            Text('Choose a category', style: textTheme.titleSmall),
            const SizedBox(height: 10),
            EventCategorySelector(
              selectedCategory: event.category,
              onSelected: onCategorySelected,
            ),
            const SizedBox(height: 18),
          ] else ...[
            Chip(
              label: Text(event.category!.label),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 14),
          ],
          Text(
            'How did this activity affect your energy?',
            style: textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          EventEnergyImpactSelector(
            selectedImpact: event.energyImpact,
            onSelected: onEnergyImpactSelected,
          ),
        ],
      ),
    );
  }

  String _formatEventTime(CalendarEvent event) {
    if (event.isAllDay) return 'All day';

    final hour = event.startTime.hour.toString().padLeft(2, '0');
    final minute = event.startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _ActivityReviewComplete extends StatelessWidget {
  const _ActivityReviewComplete({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.mintTag,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.forestGreen),
          const SizedBox(width: 10),
          const Expanded(child: Text('All completed activities are reviewed.')),
          TextButton(onPressed: onDone, child: const Text('Done')),
        ],
      ),
    );
  }
}

class _ReflectionChoiceSelector extends StatelessWidget {
  const _ReflectionChoiceSelector({
    required this.labels,
    this.icons,
    required this.selectedScore,
    required this.onSelected,
  });

  final List<String> labels;
  final List<IconData?>? icons;
  final int? selectedScore;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final score = index + 1;
        final isSelected = score == selectedScore;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 8),
            child: Material(
              color: isSelected ? AppColors.forestGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onSelected(score),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.forestGreen
                          : AppColors.sageGreen,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icons?[index] != null) ...[
                        Icon(
                          icons![index],
                          size: 17,
                          color: isSelected
                              ? Colors.white
                              : AppColors.forestGreen,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.forestGreen,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
