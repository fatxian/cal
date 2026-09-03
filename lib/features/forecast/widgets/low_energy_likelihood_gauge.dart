import 'dart:math' as math;

import 'package:flutter/material.dart';

class LowEnergyLikelihoodGauge extends StatelessWidget {
  const LowEnergyLikelihoodGauge({
    super.key,
    required this.lowEnergyLikelihood,
  });

  final double? lowEnergyLikelihood;

  @override
  Widget build(BuildContext context) {
    final score = lowEnergyLikelihood?.clamp(0.0, 1.0);
    const color = Color(0xFF8093C7);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 250,
      height: 160,
      child: CustomPaint(
        painter: _SemiCircleGaugePainter(
          value: score ?? 0,
          color: color,
          backgroundColor: const Color(0xFFE0DED8),
        ),
        child: Align(
          alignment: const Alignment(0, 0.58),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Low energy likelihood',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                score == null ? '--' : '${(score * 100).round()}%',
                style: textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SemiCircleGaugePainter extends CustomPainter {
  const _SemiCircleGaugePainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  final double value;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.095;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.width - strokeWidth,
    );
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, backgroundPaint);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * value.clamp(0.0, 1.0),
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(_SemiCircleGaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
