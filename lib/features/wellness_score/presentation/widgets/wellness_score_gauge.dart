import 'dart:math' as math;

import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/features/wellness_score/domain/entities/wellness_score_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WellnessScoreGauge extends StatelessWidget {
  const WellnessScoreGauge({
    required this.score,
    this.size,
    this.compact = false,
    super.key,
  });

  final WellnessScoreEntity score;
  final double? size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gaugeSize = size ?? (compact ? 80.w : 180.w);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: gaugeSize,
          height: gaugeSize,
          child: CustomPaint(
            painter: _GaugePainter(
              score: score.overallScore,
              backgroundColor: theme.colorScheme.outlineVariant
                  .withValues(alpha: 0.15),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${score.overallScore}',
                    style: TextStyle(
                      fontSize: compact ? 22.sp : 42.sp,
                      fontWeight: FontWeight.w800,
                      color: _scoreColor(score.overallScore),
                      height: 1,
                    ),
                  ),
                  SizedBox(height: compact ? 1.h : 4.h),
                  Text(
                    score.grade,
                    style: TextStyle(
                      fontSize: compact ? 11.sp : 16.sp,
                      fontWeight: FontWeight.w700,
                      color: _scoreColor(score.overallScore)
                          .withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!compact) ...[
          SizedBox(height: 12.h),
          Text(
            score.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  static Color _scoreColor(int score) {
    if (score >= 70) return AppColors.income;
    if (score >= 40) return AppColors.budgetWarning;
    return AppColors.expense;
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.score,
    required this.backgroundColor,
  });

  final int score;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;
    const strokeWidth = 12.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Score arc with gradient
    if (score > 0) {
      final scoreSweep = sweepAngle * (score / 100.0);

      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: const [
          Color(0xFFEF4444), // Red
          Color(0xFFF59E0B), // Yellow
          Color(0xFF22C55E), // Green
        ],
        stops: const [0.0, 0.45, 1.0],
      );

      final scorePaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        scoreSweep,
        false,
        scorePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score;
}
