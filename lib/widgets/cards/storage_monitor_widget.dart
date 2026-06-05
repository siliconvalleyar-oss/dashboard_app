import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class StorageMonitorWidget extends ConsumerWidget {
  const StorageMonitorWidget({super.key});

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
            Text('Storage Monitor', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 20),
            ...data.storageData.map((s) {
              final ratio = s.usedGB / s.totalGB;
              final sizeLabel = s.totalGB >= 1000
                  ? '${(s.totalGB / 1000).toStringAsFixed(0)}TB'
                  : '${s.totalGB.toInt()}GB';
              final usedLabel = s.totalGB >= 1000
                  ? '${(s.usedGB / 1000).toStringAsFixed(1)}TB'
                  : '${s.usedGB.toStringAsFixed(1)}GB';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.label, style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        )),
                        Text('$usedLabel / $sizeLabel', style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 6,
                        width: double.infinity,
                        color: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: ratio,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: ratio > 0.8 ? AppColors.orangePink : AppColors.cyanPurple,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ).animate().slideX(duration: 800.ms, begin: -0.5, curve: Curves.easeOutCubic),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1);
  }
}
