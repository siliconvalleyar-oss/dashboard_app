import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class BatteryWidget extends ConsumerWidget {
  const BatteryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final battery = data.batteryData;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Battery Status', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            Expanded(
              child: Center(child: _BatteryArc(percentage: battery.percentage, isCharging: battery.isCharging)),
            ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: battery.percentage),
                duration: 800.ms,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final color = value > 50 ? AppColors.success : (value > 20 ? AppColors.warning : AppColors.error);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (battery.isCharging)
                        const Icon(Icons.bolt_rounded, color: AppColors.warning, size: 18),
                      const SizedBox(width: 4),
                      Text('${value.toInt()}%', style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700, color: color,
                      )),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: Text(
                battery.isCharging ? 'Charging...' : 'Discharging',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1);
  }
}

class _BatteryArc extends StatelessWidget {
  final double percentage;
  final bool isCharging;

  const _BatteryArc({this.percentage = 78, required this.isCharging});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 90,
      child: CustomPaint(
        size: const Size(140, 90),
        painter: _BatteryArcPainter(percentage: percentage, isCharging: isCharging),
      ),
    ).animate().scale(duration: 1000.ms, curve: Curves.easeOutBack);
  }
}

class _BatteryArcPainter extends CustomPainter {
  final double percentage;
  final bool isCharging;

  _BatteryArcPainter({required this.percentage, required this.isCharging});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = 60.0;

    final bgPaint = Paint()
      ..color = const Color(0xFF2A2A30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    final endAngle = math.pi + math.pi * (percentage / 100).clamp(0.0, 1.0);
    final color = percentage > 50 ? AppColors.success : (percentage > 20 ? AppColors.warning : AppColors.error);
    final progressPaint = Paint()
      ..shader = LinearGradient(colors: [color, color.withOpacity(0.5)]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      endAngle - math.pi,
      false,
      progressPaint,
    );

    if (isCharging) {
      final boltPaint = Paint()..color = AppColors.warning;
      canvas.drawCircle(center - Offset(0, 25), 4, boltPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
