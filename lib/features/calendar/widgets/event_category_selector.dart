import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/calendar_event_category.dart';

class EventCategorySelector extends StatelessWidget {
  const EventCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final CalendarEventCategory? selectedCategory;
  final ValueChanged<CalendarEventCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CalendarEventCategory.values
          .map((category) {
            final isSelected = selectedCategory == category;

            return ChoiceChip(
              key: ValueKey('event-category-${category.name}'),
              label: Text(category.label),
              selected: isSelected,
              showCheckmark: true,
              onSelected: (_) => onSelected(category),
              selectedColor: AppColors.mintTag,
              backgroundColor: AppColors.surface,
              checkmarkColor: AppColors.forestGreen,
              labelStyle: textTheme.labelMedium?.copyWith(
                color: isSelected ? AppColors.ink : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.forestGreen : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          })
          .toList(growable: false),
    );
  }
}
