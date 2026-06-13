import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class CircularProgressWidget extends ConsumerWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final values = data.circularProgressValues;

    final labels = ['Onboarding', 'Engagement', 'Retention'];
    final gradients = [AppColors.cyanPurple, AppColors.orangePink, AppColors.greenBlue];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completion Rate', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 24),
            Row(
              children: List.generate(values.length, (i) {
                if (i >= labels.length) return const SizedBox();
                return Padding(
                  padding: EdgeInsets.only(right: i < values.length - 1 ? 12 : 0),
                  child: _animatedRing(
                    context,
                    values[i],
                    gradients[i % gradients.length],
                    labels[i % labels.length],
                    isDark,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _animatedRing(BuildContext context, double percent, Gradient gradient, String label, bool isDark) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: percent),
        duration: 1500.ms,
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Column(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: value / 100,
                    gradient: gradient,
                    isDark: isDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('${value.toInt()}%', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: gradient.colors.first,
              )),
              Text(label, style: TextStyle(
                fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              )),
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final bool isDark;

  _RingPainter({required this.progress, required this.gradient, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A30) : const Color(0xFFE8EAF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);

      final endAngle = -math.pi / 2 + 2 * math.pi * progress;
      final dotX = center.dx + radius * math.cos(endAngle);
      final dotY = center.dy + radius * math.sin(endAngle);
      final glowPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(dotX, dotY), 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}
