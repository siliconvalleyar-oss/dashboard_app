import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class RadarChartWidget extends ConsumerWidget {
  const RadarChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final isDark = context.isDark;

    final categories = ['Tech', 'Health', 'Finance', 'Education', 'Energy'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Performance Radar', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 4),
            Text('Sector Comparison', style: TextStyle(
              fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            )),
            const SizedBox(height: 20),
            Expanded(
              child: fl.RadarChart(
                fl.RadarChartData(
                  radarShape: fl.RadarShape.polygon,
                  tickCount: 5,
                  tickBorderData: BorderSide(
                    color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder,
                  ),
                  gridBorderData: BorderSide(
                    color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder,
                  ),
                  titlePositionPercentageOffset: 0.15,
                  titleTextStyle: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  getTitle: (index, angle) => fl.RadarChartTitle(text: categories[index]),
                  dataSets: [
                    fl.RadarDataSet(
                      fillColor: const Color(0xFF4EF2FF).withOpacity(0.15),
                      borderColor: const Color(0xFF4EF2FF),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: data.radarData[0].values.map((v) => fl.RadarEntry(value: v)).toList(),
                    ),
                    fl.RadarDataSet(
                      fillColor: const Color(0xFFB05CFF).withOpacity(0.15),
                      borderColor: const Color(0xFFB05CFF),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: data.radarData[1].values.map((v) => fl.RadarEntry(value: v)).toList(),
                    ),
                    fl.RadarDataSet(
                      fillColor: const Color(0xFFFFC14D).withOpacity(0.15),
                      borderColor: const Color(0xFFFFC14D),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: data.radarData[2].values.map((v) => fl.RadarEntry(value: v)).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendChip('Sector A', const Color(0xFF4EF2FF)),
                const SizedBox(width: 16),
                _legendChip('Sector B', const Color(0xFFB05CFF)),
                const SizedBox(width: 16),
                _legendChip('Sector C', const Color(0xFFFFC14D)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _legendChip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF909090))),
      ],
    );
  }
}
