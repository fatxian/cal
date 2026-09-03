part of '../screens/forecast_screen.dart';

String _predictionImagePathForScore(double? score) {
  final likelihood = score?.clamp(0.0, 1.0) ?? 0.0;

  if (likelihood >= 0.75) return 'assets/images/prediction_1.png';
  if (likelihood >= 0.50) return 'assets/images/prediction_2.png';
  if (likelihood >= 0.25) return 'assets/images/prediction_3.png';

  return 'assets/images/prediction_4.png';
}

class _ResponseButton extends StatelessWidget {
  const _ResponseButton({
    required this.width,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final double width;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 21),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, maxLines: 1, softWrap: false),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          foregroundColor: isSelected ? Colors.white : AppColors.ink,
          backgroundColor: isSelected ? AppColors.forestGreen : null,
          side: BorderSide(
            color: isSelected ? AppColors.forestGreen : AppColors.sageGreen,
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
