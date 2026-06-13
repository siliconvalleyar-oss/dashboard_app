import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/dashboard_models.dart';
import '../../providers/app_providers.dart';

class CircularProgressWidget extends ConsumerWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final crypto = data.bottomKpis;

    const wanted = {'Bitcoin', 'Ethereum', 'XRP'};
    final selected = crypto.where((c) => wanted.contains(c.label)).toList();
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
              children: List.generate(selected.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: i < selected.length - 1 ? 12 : 0),
                  child: _animatedRing(context, selected[i], gradients[i], isDark),
                );
              }),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  double _ringValue(BottomKpi coin) {
    const refs = {'Bitcoin': 150000.0, 'Ethereum': 5000.0, 'XRP': 3.0};
    final max = refs[coin.label] ?? 100.0;
    return (coin.value / max * 100).clamp(0, 100);
  }

  String _formatPrice(double value) {
    if (value >= 1000) return '\$${(value).toStringAsFixed(0)}';
    if (value >= 1) return '\$${(value).toStringAsFixed(2)}';
    return '\$${(value).toStringAsFixed(4)}';
  }

  Widget _animatedRing(BuildContext context, BottomKpi coin, Gradient gradient, bool isDark) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _ringValue(coin)),
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
              Text(_formatPrice(coin.value), style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: gradient.colors.first,
              )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    coin.isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    size: 10,
                    color: coin.isPositive ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 2),
                  Text('${coin.change.toStringAsFixed(1)}%', style: TextStyle(
                    fontSize: 10,
                    color: coin.isPositive ? AppColors.success : AppColors.error,
                  )),
                ],
              ),
              const SizedBox(height: 2),
              Text(coin.label, style: TextStyle(
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
