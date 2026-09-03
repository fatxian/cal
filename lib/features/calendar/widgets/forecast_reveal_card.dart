import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ForecastRevealCard extends StatelessWidget {
  const ForecastRevealCard({
    super.key,
    required this.hasSuccessfulSync,
    required this.hasPrediction,
    required this.isLoading,
    required this.uncategorizedEventCount,
    required this.onTap,
  });

  final bool hasSuccessfulSync;
  final bool hasPrediction;
  final bool isLoading;
  final int uncategorizedEventCount;
  final VoidCallback onTap;

  static const _accentBlue = Color(0xFF4F7890);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: const Color(0xFFEAF5FA),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.skyBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wb_sunny_outlined,
                  color: _accentBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    if (isLoading)
                      const LinearProgressIndicator()
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _actionLabel,
                              style: textTheme.bodyLarge?.copyWith(
                                color: _accentBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.chevron_right,
                            color: _accentBlue,
                            size: 21,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title {
    if (isLoading) return 'Preparing today\'s forecast...';
    if (hasSuccessfulSync && uncategorizedEventCount > 0) {
      return 'Review today\'s activities';
    }
    if (hasPrediction) return 'Today\'s forecast is ready';
    if (hasSuccessfulSync) return 'Today\'s forecast is ready to reveal';

    return 'Today\'s forecast is waiting';
  }

  String get _actionLabel {
    if (hasSuccessfulSync && uncategorizedEventCount > 0) {
      return uncategorizedEventCount == 1
          ? '1 activity needs a category'
          : '$uncategorizedEventCount activities need categories';
    }
    if (hasPrediction) return 'View today\'s forecast';
    if (hasSuccessfulSync) return 'Reveal today\'s forecast';

    return 'Sync calendar to reveal';
  }
}
