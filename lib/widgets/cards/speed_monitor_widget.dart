import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class SpeedMonitorWidget extends ConsumerWidget {
  const SpeedMonitorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final speed = data.speedData;
    final ratio = speed.currentMbps / speed.maxMbps;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Speed', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: ratio),
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return CustomPaint(
                          size: const Size(120, 120),
                          painter: _SpeedGaugePainter(
                            value: value,
                            gradient: AppColors.greenBlue,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: speed.currentMbps),
                          duration: 800.ms,
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Text('${value.toInt()}', style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ));
                          },
                        ),
                        Text('Mbps', style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _speedStat('Download', '${speed.currentMbps.toInt()}', 'Mbps', AppColors.success, isDark),
                _speedStat('Upload', '${speed.uploadMbps.toInt()}', 'Mbps', AppColors.info, isDark),
                _speedStat('Max', '${speed.maxMbps.toInt()}', 'Mbps', AppColors.warning, isDark),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _speedStat(String label, String value, String unit, Color color, bool isDark) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(unit, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
      ],
    );
  }
}

class _SpeedGaugePainter extends CustomPainter {
  final double value;
  final Gradient gradient;
  final bool isDark;

  _SpeedGaugePainter({required this.value, required this.gradient, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A30) : const Color(0xFFE8EAF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.75 * 3.14159, 1.5 * 3.14159, false, bgPaint,
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.75 * 3.14159,
      1.5 * 3.14159 * value.clamp(0.0, 1.0),
      false, progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeedGaugePainter old) => old.value != value;
}
