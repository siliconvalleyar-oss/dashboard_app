import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/dashboard_models.dart';
import '../../providers/app_providers.dart';

class LineChartAnalyticsWidget extends ConsumerWidget {
  const LineChartAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;

    return _ChartCard(
      title: 'User Analytics',
      subtitle: 'New vs Lost Users — Last 12 Months',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegend(context),
          const SizedBox(height: 16),
          Expanded(
            child: fl.LineChart(
              fl.LineChartData(
                gridData: fl.FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
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
                        '${value.toInt()}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                      ),
                    ),
                  ),
                  bottomTitles: fl.AxisTitles(
                    sideTitles: fl.SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final months = ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov'];
                        final idx = value.toInt() ~/ 2;
                        if (idx >= months.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(months[idx], style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                        );
                      },
                    ),
                  ),
                  topTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
                  rightTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
                ),
                borderData: fl.FlBorderData(show: false),
                minY: 0,
                maxY: 600,
                lineBarsData: [
                  _buildLine(data.newUsers, const Color(0xFF4EF2FF), true),
                  _buildLine(data.lostUsers, const Color(0xFFFF5EA8), false),
                ],
                lineTouchData: fl.LineTouchData(
                  enabled: true,
                  touchTooltipData: fl.LineTouchTooltipData(
                    getTooltipColor: (spot) => isDark ? AppColors.darkCardSecondary : AppColors.lightCardPrimary,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) => spots.map((spot) {
                      final isNew = spot.barIndex == 0;
                      return fl.LineTooltipItem(
                        '${isNew ? "New" : "Lost"}: ${spot.y.toInt()}',
                        TextStyle(color: isNew ? const Color(0xFF4EF2FF) : const Color(0xFFFF5EA8), fontWeight: FontWeight.w600, fontSize: 13),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  fl.LineChartBarData _buildLine(List<ChartPoint> points, Color color, bool filled) {
    return fl.LineChartBarData(
      spots: points.map((p) => fl.FlSpot(p.x, p.y)).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: fl.FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => fl.FlDotCirclePainter(radius: 3, color: color, strokeWidth: 2, strokeColor: color.withOpacity(0.3)),
      ),
      belowBarData: filled
          ? fl.BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withOpacity(0.3), color.withOpacity(0.0)]))
          : fl.BarAreaData(show: false),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _legendDot('New Users', const Color(0xFF4EF2FF)),
        const SizedBox(width: 20),
        _legendDot('Lost Users', const Color(0xFFFF5EA8)),
      ],
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF909090))),
    ]);
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
          const SizedBox(height: 16),
          Expanded(child: child),
        ]),
      ),
    );
  }
}
