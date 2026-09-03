import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/event_energy_impact.dart';

class EventEnergyImpactSelector extends StatelessWidget {
  const EventEnergyImpactSelector({
    super.key,
    required this.selectedImpact,
    required this.onSelected,
  });

  final EventEnergyImpact? selectedImpact;
  final ValueChanged<EventEnergyImpact> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (
          var index = 0;
          index < EventEnergyImpact.values.length;
          index++
        ) ...[
          Expanded(
            child: _ImpactChoice(
              impact: EventEnergyImpact.values[index],
              selected: selectedImpact == EventEnergyImpact.values[index],
              onTap: () => onSelected(EventEnergyImpact.values[index]),
            ),
          ),
          if (index != EventEnergyImpact.values.length - 1)
            const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ImpactChoice extends StatelessWidget {
  const _ImpactChoice({
    required this.impact,
    required this.selected,
    required this.onTap,
  });

  final EventEnergyImpact impact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.forestGreen : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: ValueKey('event-impact-${impact.name}'),
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 46),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.forestGreen : AppColors.sageGreen,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_icon != null) ...[
                  Icon(
                    _icon,
                    size: 17,
                    color: selected ? Colors.white : AppColors.forestGreen,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  impact.label,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? Colors.white : AppColors.forestGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData? get _icon {
    return switch (impact) {
      EventEnergyImpact.decreased => Icons.arrow_downward,
      EventEnergyImpact.unchanged => null,
      EventEnergyImpact.increased => Icons.arrow_upward,
    };
  }
}
