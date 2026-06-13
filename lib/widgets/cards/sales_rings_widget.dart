import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class SalesRingsWidget extends ConsumerWidget {
  const SalesRingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final direct = data.directSales;
    final reseller = data.resellerSales;

    return Card(
      key: ValueKey('sales_${data.animationSeed}'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales Distribution', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _RingItem(
                    key: ValueKey('direct_${data.animationSeed}'),
                    label: 'Direct Sales',
                    value: direct,
                    color: const Color(0xFF4EF2FF),
                    gradient: AppColors.cyanPurple,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _RingItem(
                    key: ValueKey('reseller_${data.animationSeed}'),
                    label: 'Resellers',
                    value: reseller,
                    color: const Color(0xFFFFC14D),
                    gradient: AppColors.orangePink,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1);
  }
}

class _RingItem extends StatefulWidget {
  final String label;
  final double value;
  final Color color;
  final Gradient gradient;
  final bool isDark;

  const _RingItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.gradient,
    required this.isDark,
  });

  @override
  State<_RingItem> createState() => _RingItemState();
}

class _RingItemState extends State<_RingItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void didUpdateWidget(_RingItem old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: _SalesRingPainter(
                  progress: _animation.value * widget.value / 100,
                  gradient: widget.gradient,
                  isDark: widget.isDark,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('${widget.value.toInt()}%', style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: widget.color,
            )),
            Text(widget.label, style: TextStyle(
              fontSize: 11,
              color: widget.isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            )),
          ],
        );
      },
    );
  }
}

class _SalesRingPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final bool isDark;

  _SalesRingPainter({required this.progress, required this.gradient, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final glowPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius + 4))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 4, glowPaint);

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A30) : const Color(0xFFE8EAF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SalesRingPainter old) => old.progress != progress;
}
