import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/daily_intention.dart';
import '../models/forecast_reflection_option.dart';
import '../services/forecast_intention_option_page_builder.dart';

class ForecastIntentionSection extends StatefulWidget {
  const ForecastIntentionSection({
    super.key,
    required this.intentionOptions,
    required this.isLoading,
    required this.selectedIntentionOption,
    required this.dailyIntention,
    required this.hasCalendarChanged,
    required this.isEditingIntention,
    required this.onIntentionSelected,
    required this.onReview,
    required this.onKeepCurrent,
    required this.onEdit,
  });

  final List<ForecastIntentionOption> intentionOptions;
  final bool isLoading;
  final ForecastIntentionOption? selectedIntentionOption;
  final DailyIntention? dailyIntention;
  final bool hasCalendarChanged;
  final bool isEditingIntention;
  final ValueChanged<ForecastIntentionOption> onIntentionSelected;
  final VoidCallback onReview;
  final VoidCallback onKeepCurrent;
  final VoidCallback onEdit;

  @override
  State<ForecastIntentionSection> createState() =>
      _ForecastIntentionSectionState();
}

class _ForecastIntentionSectionState extends State<ForecastIntentionSection> {
  static const optionPageBuilder = ForecastIntentionOptionPageBuilder();

  int ideaPageIndex = 0;

  @override
  void initState() {
    super.initState();
    final selectedPage = _pageContainingSelection();
    ideaPageIndex = selectedPage == -1 ? 0 : selectedPage;
  }

  @override
  void didUpdateWidget(covariant ForecastIntentionSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedPage = _pageContainingSelection();
    if (selectedPage != -1) {
      ideaPageIndex = selectedPage;
      return;
    }

    final count = _ideaPages.length;
    if (count == 0 || ideaPageIndex >= count) {
      ideaPageIndex = 0;
    }
  }

  ForecastIntentionOptionPages get _optionPages =>
      optionPageBuilder.build(widget.intentionOptions);

  List<List<ForecastIntentionOption>> get _ideaPages => _optionPages.pages;

  ForecastIntentionOption? get _noChangeOption => _optionPages.noChangeOption;

  int _pageContainingSelection() {
    return _optionPages.pageContaining(widget.selectedIntentionOption);
  }

  void _showOtherIdeas() {
    final count = _ideaPages.length;
    if (count < 2) return;

    setState(() {
      ideaPageIndex = (ideaPageIndex + 1) % count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set today\'s intention',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.ink,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 14),
        if (widget.dailyIntention != null) ...[
          _IntentionStatusCard(
            intention: widget.dailyIntention!,
            selectedOption: widget.selectedIntentionOption,
            hasCalendarChanged: widget.hasCalendarChanged,
            isEditing: widget.isEditingIntention,
            onReview: widget.onReview,
            onKeepCurrent: widget.onKeepCurrent,
            onEdit: widget.onEdit,
          ),
          const SizedBox(height: 14),
        ],
        if (widget.dailyIntention == null || widget.isEditingIntention)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What intention would you like to set?',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose one small option to keep in mind today.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  if (widget.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    ..._visibleIdeaOptions.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _IntentionChoice(
                          key: ValueKey(
                            'intention-${option.factor.type.name}-'
                            '${option.adjustment.type.name}-'
                            '${option.adjustment.label}',
                          ),
                          label: _displayAdjustment(option.adjustment),
                          isSelected: option == widget.selectedIntentionOption,
                          onTap: () => widget.onIntentionSelected(option),
                        ),
                      ),
                    ),
                  if (!widget.isLoading && _ideaPages.length > 1) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        key: const ValueKey('show-other-intention-ideas'),
                        onPressed: _showOtherIdeas,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Show me other ideas'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (!widget.isLoading && _noChangeOption != null)
                    _IntentionChoice(
                      key: const ValueKey('no-change-intention'),
                      label: 'No change today',
                      isSelected:
                          _noChangeOption == widget.selectedIntentionOption,
                      onTap: () => widget.onIntentionSelected(_noChangeOption!),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<ForecastIntentionOption> get _visibleIdeaOptions {
    final pages = _ideaPages;
    if (pages.isEmpty) return const [];

    return pages[ideaPageIndex % pages.length];
  }

  String _displayAdjustment(DailyAdjustment adjustment) {
    final startTime = adjustment.startTime;
    if (startTime == null ||
        adjustment.label.contains(RegExp(r'\d{1,2}:\d{2}'))) {
      return adjustment.label;
    }

    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '${adjustment.label} around $hour:$minute';
  }
}

class _IntentionStatusCard extends StatelessWidget {
  const _IntentionStatusCard({
    required this.intention,
    required this.selectedOption,
    required this.hasCalendarChanged,
    required this.isEditing,
    required this.onReview,
    required this.onKeepCurrent,
    required this.onEdit,
  });

  final DailyIntention intention;
  final ForecastIntentionOption? selectedOption;
  final bool hasCalendarChanged;
  final bool isEditing;
  final VoidCallback onReview;
  final VoidCallback onKeepCurrent;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = hasCalendarChanged
        ? 'Your calendar changed'
        : 'Your intention for today';
    final description = hasCalendarChanged
        ? isEditing
              ? 'Choose an updated option below, or keep your current intention.'
              : 'Your current intention is still saved. Review it if you would like.'
        : _displayAdjustment(intention.adjustment);

    return Card(
      color: AppColors.surfaceSoft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event_available_outlined,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(color: AppColors.ink),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: textTheme.bodyLarge),
            if (!hasCalendarChanged) ...[
              const SizedBox(height: 10),
              Text(
                _intentionExplanation(),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (hasCalendarChanged) ...[
              const SizedBox(height: 8),
              Text(
                'Current intention',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                intention.adjustment.label,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (hasCalendarChanged)
              if (isEditing)
                OutlinedButton(
                  onPressed: onKeepCurrent,
                  child: const Text('Keep current'),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: onReview,
                        child: const Text('Review'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onKeepCurrent,
                        child: const Text('Keep current'),
                      ),
                    ),
                  ],
                )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onEdit,
                  child: const Text('View or edit'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _intentionExplanation() {
    final option = selectedOption;
    if (intention.adjustment.type == DailyAdjustmentType.noChange) {
      return 'You chose to keep today as it is.';
    }
    if (option == null) {
      return 'This is the intention you chose to keep in mind today.';
    }

    final factor = option.factor.label;
    return switch (option.sourceLabel) {
      'Based on what you noticed' =>
        '$factor was one of the factors you expected could decrease your energy today.',
      'Based on your forecast' =>
        '$factor was one of the factors Cal expected could decrease your energy today.',
      'Based on what you noticed and your forecast' =>
        'You and Cal both identified $factor as something that could decrease your energy today.',
      'Based on what you expect may support you' =>
        '$factor was one of the factors you expected could increase your energy today.',
      'Based on what your forecast identifies as supportive' =>
        '$factor was one of the factors Cal expected could increase your energy today.',
      'Based on what you expect and your forecast' =>
        'You and Cal both identified $factor as something that could increase your energy today.',
      _ => 'This is a general idea you can try if it feels useful today.',
    };
  }

  String _displayAdjustment(DailyAdjustment adjustment) {
    final startTime = adjustment.startTime;
    if (startTime == null ||
        adjustment.label.contains(RegExp(r'\d{1,2}:\d{2}'))) {
      return adjustment.label;
    }

    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '${adjustment.label} around $hour:$minute';
  }
}

class _IntentionChoice extends StatelessWidget {
  const _IntentionChoice({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.mintTag : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.forestGreen : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? AppColors.forestGreen : AppColors.ink,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.forestGreen),
            ],
          ),
        ),
      ),
    );
  }
}
