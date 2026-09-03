import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/daily_intention.dart';
import '../models/forecast_reflection_option.dart';

class ForecastFactorDropdown extends StatelessWidget {
  const ForecastFactorDropdown({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  final List<ForecastFactorOption> options;
  final ForecastFactorOption? selectedOption;
  final ValueChanged<ForecastFactorOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedType =
        options.any((option) => option.type == selectedOption?.type)
        ? selectedOption?.type
        : null;

    return DropdownButtonFormField<ForecastFactorType>(
      key: ValueKey(selectedType),
      initialValue: selectedType,
      isExpanded: true,
      menuMaxHeight: 360,
      hint: const Text('Select a factor'),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.forestGreen,
            width: 1.5,
          ),
        ),
      ),
      items: [
        for (final option in options)
          DropdownMenuItem(
            value: option.type,
            child: Text(option.label, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (type) {
        if (type == null) return;
        onSelected(options.firstWhere((option) => option.type == type));
      },
    );
  }
}
