import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class KpiCardsWidget extends ConsumerWidget {
  const KpiCardsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: data.kpiCards.asMap().entries.map((entry) {
        final idx = entry.key;
        final kpi = entry.value;
        final isPositive = kpi.change >= 0;

        return SizedBox(
          width: context.isMobile ? double.infinity : (context.width - 120) / 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kpi.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(kpi.icon, color: kpi.color, size: 20),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isPositive ? AppColors.success : AppColors.error).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              size: 14,
                              color: isPositive ? AppColors.success : AppColors.error,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${kpi.change.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isPositive ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(kpi.title, style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  )),
                  const SizedBox(height: 4),
                  AnimatedCount(
                    value: kpi.value,
                    prefix: kpi.prefix,
                    suffix: kpi.suffix,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    delay: (idx * 100).ms,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }
}

class AnimatedCount extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final Color color;
  final Duration delay;

  const AnimatedCount({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    required this.color,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    Future.delayed(widget.delay, () {
      if (mounted) {
        _started = true;
        _controller.forward();
      }
    });
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
        final display = _started ? widget.value * _animation.value : 0.0;
        String formatted;
        if (display >= 10000) {
          formatted = '${(display / 1000).toStringAsFixed(1)}k';
        } else {
          formatted = display.toStringAsFixed(0);
        }
        return Text(
          '${widget.prefix}$formatted${widget.suffix}',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: widget.color),
        );
      },
    );
  }
}
