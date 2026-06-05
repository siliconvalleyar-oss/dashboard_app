import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class TrackingDashboardWidget extends ConsumerWidget {
  const TrackingDashboardWidget({super.key});

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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanPurple,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Kimura', style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    )),
                    const SizedBox(height: 2),
                    Text('Joined Dec 2024', style: TextStyle(
                      fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _statBox('Total Completed', '1,847', AppColors.success, isDark),
                const SizedBox(width: 12),
                _statBox('Monthly Avg', '154', AppColors.info, isDark),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: data.donutStats.map((d) => Expanded(
                  child: _DonutMini(
                    label: d.label,
                    value: d.value,
                    color: d.color,
                    isDark: isDark,
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _statBox(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

class _DonutMini extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isDark;

  const _DonutMini({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              fl.PieChart(
                fl.PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 18,
                  sections: [
                    fl.PieChartSectionData(
                      value: value,
                      color: color,
                      radius: 22,
                      showTitle: false,
                    ),
                    fl.PieChartSectionData(
                      value: 100 - value,
                      color: isDark ? const Color(0xFF2A2A30) : const Color(0xFFE8EAF0),
                      radius: 22,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Text('${value.toInt()}%', style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              )),
            ],
          ),
        ).animate().scale(duration: 600.ms, delay: 200.ms),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        ), textAlign: TextAlign.center),
      ],
    );
  }
}
