import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/dashboard_models.dart';
import '../../providers/app_providers.dart';

class BottomKpiSectionWidget extends ConsumerWidget {
  const BottomKpiSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yearly Performance', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 20),
            Row(
              children: data.bottomKpis.map((kpi) => Expanded(
                child: _kpiTile(kpi, isDark, data),
              )).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: CustomPaint(
                size: const Size(double.infinity, 40),
                painter: _MiniTrendPainter(isDark: isDark),
              ),
            ).animate().fadeIn(duration: 800.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _kpiTile(BottomKpi kpi, bool isDark, DashboardData data) {
    return Column(
      children: [
        Icon(kpi.icon, size: 20, color: kpi.isPositive ? AppColors.success : AppColors.error),
        const SizedBox(height: 8),
        Text(
          kpi.value >= 10000
              ? '\$${kpi.value ~/ 1000},${(kpi.value % 1000).toStringAsFixed(0).padLeft(3, '0')}'
              : kpi.value < 1
                  ? '\$${kpi.value.toStringAsFixed(4)}'
                  : '\$${kpi.value.toStringAsFixed(kpi.value >= 100 ? 0 : 2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (kpi.isPositive ? AppColors.success : AppColors.error).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                kpi.isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 12,
                color: kpi.isPositive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 2),
              Text(
                '${kpi.change.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kpi.isPositive ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(kpi.label, style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        )),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: (100 * data.bottomKpis.indexOf(kpi)).ms).slideY(begin: 0.1);
  }
}

class _MiniTrendPainter extends CustomPainter {
  final bool isDark;

  _MiniTrendPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppColors.greenBlue.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.2, size.height * 0.2,
      size.width * 0.4, size.height * 0.7,
      size.width * 0.5, size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.6, size.height * 0.1,
      size.width * 0.8, size.height * 0.6,
      size.width, size.height * 0.2,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniTrendPainter oldDelegate) => false;
}
