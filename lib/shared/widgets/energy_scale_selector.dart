import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EnergyScaleSelector extends StatelessWidget {
  const EnergyScaleSelector({
    super.key,
    required this.selectedScore,
    required this.onScoreSelected,
  });

  final int selectedScore;
  final ValueChanged<int> onScoreSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: const _InsetSliderTrackShape(horizontalInset: 14),
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: Slider(
            value: selectedScore.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: selectedScore.toString(),
            padding: EdgeInsets.zero,
            onChanged: (value) {
              onScoreSelected(value.round());
            },
          ),
        ),
        const SizedBox(height: 14),
        _ScaleNumbers(selectedScore: selectedScore),
        const SizedBox(height: 14),
        Row(
          children: [
            Text(
              'Low',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
            const Spacer(),
            Text(
              'High',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsetSliderTrackShape extends RoundedRectSliderTrackShape {
  const _InsetSliderTrackShape({required this.horizontalInset});

  final double horizontalInset;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 0;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;

    return Rect.fromLTWH(
      offset.dx + horizontalInset,
      trackTop,
      parentBox.size.width - horizontalInset * 2,
      trackHeight,
    );
  }
}

class _ScaleNumbers extends StatelessWidget {
  const _ScaleNumbers({required this.selectedScore});

  final int selectedScore;

  @override
  Widget build(BuildContext context) {
    const circleSize = 28.0;

    return SizedBox(
      height: circleSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - circleSize;

          return Stack(
            children: [
              for (var index = 0; index < 5; index++)
                Positioned(
                  left: availableWidth * index / 4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: circleSize,
                    height: circleSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index + 1 == selectedScore
                          ? AppColors.forestGreen
                          : AppColors.surfaceSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: index + 1 == selectedScore
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
