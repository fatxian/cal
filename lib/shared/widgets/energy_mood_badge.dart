import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'energy_mood.dart';

class EnergyMoodBadge extends StatelessWidget {
  const EnergyMoodBadge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final mood = EnergyMood.fromScore(score);
    final color = _colorForScore(score);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.28), width: 4),
          ),
          child: Center(
            child: Image.asset(mood.assetPath, width: 46, height: 46),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Color _colorForScore(int score) {
    return switch (score) {
      1 => AppColors.lowEnergy,
      2 => AppColors.skyBlue,
      3 => AppColors.lavender,
      4 => AppColors.sunshine,
      _ => AppColors.highEnergy,
    };
  }
}
