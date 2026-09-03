import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ModelLearningProgress extends StatelessWidget {
  const ModelLearningProgress({
    super.key,
    required this.completedSampleCount,
    required this.hasLowerEnergySample,
    required this.hasHigherEnergySample,
  });

  static const int requiredSampleCount = 7;

  final int completedSampleCount;
  final bool hasLowerEnergySample;
  final bool hasHigherEnergySample;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayedCount = math.min(completedSampleCount, requiredSampleCount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: displayedCount / requiredSampleCount,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceSoft,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.forestGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$displayedCount of $requiredSampleCount reflection days',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ReadinessStatus(
          label: 'Lower-energy reflection',
          isAvailable: hasLowerEnergySample,
        ),
        const SizedBox(height: 6),
        _ReadinessStatus(
          label: 'Higher-energy reflection',
          isAvailable: hasHigherEnergySample,
        ),
      ],
    );
  }
}

class _ReadinessStatus extends StatelessWidget {
  const _ReadinessStatus({required this.label, required this.isAvailable});

  final String label;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isAvailable ? AppColors.forestGreen : AppColors.textSecondary;

    return Row(
      children: [
        Icon(
          isAvailable
              ? Icons.check_circle_outline
              : Icons.radio_button_unchecked,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            isAvailable ? '$label available' : '$label needed',
            style: textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
