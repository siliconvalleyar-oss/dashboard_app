import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/dashboard_models.dart';
import '../../providers/app_providers.dart';

class AreaAnalyticsChartWidget extends ConsumerWidget {
  const AreaAnalyticsChartWidget({super.key});

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
            Text('Traffic Analytics', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 4),
            Text('Views, New Users & Returning', style: TextStyle(
              fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            )),
            const SizedBox(height: 16),
            _buildLegend(),
            const SizedBox(height: 12),
            Expanded(
              child: fl.LineChart(
                fl.LineChartData(
                  gridData: fl.FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => fl.FlLine(
                      color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: fl.FlTitlesData(
                    leftTitles: fl.AxisTitles(
                      sideTitles: fl.SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                        ),
                      ),
                    ),
                    bottomTitles: fl.AxisTitles(
                      sideTitles: fl.SideTitles(showTitles: false),
                    ),
                    topTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
                    rightTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
                  ),
                  borderData: fl.FlBorderData(show: false),
                  minY: 0,
                  maxY: 1000,
                  lineBarsData: [
                    _buildAreaLine(data.areaViews, const Color(0xFF4EF2FF)),
                    _buildAreaLine(data.areaNewUsers, const Color(0xFF64FFC8)),
                    _buildAreaLine(data.areaReturning, const Color(0xFFFFC14D)),
                  ],
                  lineTouchData: fl.LineTouchData(
                    enabled: true,
                    touchTooltipData: fl.LineTouchTooltipData(
                      getTooltipColor: (spot) => isDark ? AppColors.darkCardSecondary : AppColors.lightCardPrimary,
                      tooltipRoundedRadius: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1);
  }

  fl.LineChartBarData _buildAreaLine(List<ChartPoint> points, Color color) {
    return fl.LineChartBarData(
      spots: points.map((p) => fl.FlSpot(p.x, p.y)).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2,
      dotData: fl.FlDotData(show: false),
      belowBarData: fl.BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _dot('Views', const Color(0xFF4EF2FF)),
        const SizedBox(width: 16),
        _dot('New Users', const Color(0xFF64FFC8)),
        const SizedBox(width: 16),
        _dot('Returning', const Color(0xFFFFC14D)),
      ],
    );
  }

  Widget _dot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF909090))),
      ],
    );
  }
}
