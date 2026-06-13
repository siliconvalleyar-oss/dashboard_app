import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class OverviewTableWidget extends ConsumerWidget {
  const OverviewTableWidget({super.key});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Traffic Overview', style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_rounded, size: 14, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                      const SizedBox(width: 4),
                      Text('Filter', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  _headerCell('Category', 0, isDark),
                  _headerCell('Quantity', 1, isDark),
                  _headerCell('Percentage', 2, isDark),
                ],
              ),
            ),
            const Divider(),
            // Table rows
            Expanded(
              child: ListView.separated(
                itemCount: data.tableData.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final row = data.tableData[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: row.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(row.category, style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatNumber(row.quantity),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '${row.percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: row.color,
                                ),
                              ),
                              const Spacer(),
                              // Mini bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Container(
                                  width: 40, height: 4,
                                  color: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: row.percentage / 100,
                                    child: Container(color: row.color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(begin: 0.05);
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms).slideY(begin: 0.1);
  }

  Widget _headerCell(String label, int flex, bool isDark) {
    return Expanded(
      flex: flex == 0 ? 2 : 1,
      child: Text(label, style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        letterSpacing: 0.5,
      )),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toString();
  }
}
