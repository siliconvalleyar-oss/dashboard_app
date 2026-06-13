import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class WaveStatisticsWidget extends ConsumerWidget {
  const WaveStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final wave = data.waveStats;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wave Statistics', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: CustomPaint(
                size: const Size(double.infinity, 80),
                painter: _WavePainter(
                  isDark: isDark,
                  seed: data.animationSeed,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _waveStat(Icons.favorite_rounded, '${_formatK(wave.likes)}', 'Likes', AppColors.error, isDark),
                const SizedBox(width: 12),
                _waveStat(Icons.visibility_rounded, '${_formatK(wave.views)}', 'Views', AppColors.info, isDark),
                const SizedBox(width: 12),
                _waveStat(Icons.graphic_eq_rounded, '${wave.engagement}%', 'Engagement', AppColors.success, isDark),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  String _formatK(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toString();
  }

  Widget _waveStat(IconData icon, String value, String label, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
              builder: (context, v, child) {
                final display = value.contains('k')
                    ? '${(v / 1000).toStringAsFixed(1)}k'
                    : value.contains('%')
                        ? '${v.toStringAsFixed(1)}%'
                        : v.toInt().toString();
                return Text(display, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color));
              },
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final bool isDark;
  final int seed;

  _WavePainter({required this.isDark, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final time = seed * 0.3;

    final paint1 = Paint()
      ..shader = AppColors.cyanPurple.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 +
          math.sin((x + time) * 0.05) * 15 +
          math.sin((x + time * 2) * 0.08) * 8 +
          math.cos((x + time) * 0.03) * 10;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint1);

    final paint2 = Paint()
      ..shader = AppColors.orangePink.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + 15 +
          math.sin((x + time * 0.7) * 0.06 + 2) * 12 +
          math.cos((x + time * 1.3) * 0.04 + 1) * 8;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.seed != seed;
}
