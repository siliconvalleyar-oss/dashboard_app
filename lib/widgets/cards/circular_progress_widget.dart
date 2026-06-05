import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';

class CircularProgressWidget extends StatefulWidget {
  const CircularProgressWidget({super.key});

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> with TickerProviderStateMixin {
  late AnimationController _ctrl1;
  late AnimationController _ctrl2;
  late AnimationController _ctrl3;

  @override
  void initState() {
    super.initState();
    _ctrl1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _ctrl2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _ctrl3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl1.forward();
      Future.delayed(const Duration(milliseconds: 200), () => _ctrl2.forward());
      Future.delayed(const Duration(milliseconds: 400), () => _ctrl3.forward());
    });
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
              children: [
                _animatedRing(context, 30, AppColors.cyanPurple, 'Onboarding', _ctrl1, isDark),
                const SizedBox(width: 12),
                _animatedRing(context, 50, AppColors.orangePink, 'Engagement', _ctrl2, isDark),
                const SizedBox(width: 12),
                _animatedRing(context, 80, AppColors.greenBlue, 'Retention', _ctrl3, isDark),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _animatedRing(BuildContext context, double percent, Gradient gradient, String label, AnimationController ctrl, bool isDark) {
    return Expanded(
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: ctrl.value * percent / 100,
                    gradient: gradient,
                    isDark: isDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('${percent.toInt()}%', style: TextStyle(
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

    // Background ring
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A30) : const Color(0xFFE8EAF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        paint,
      );

      // Glow dot at end
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
