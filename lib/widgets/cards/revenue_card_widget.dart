import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class RevenueCardWidget extends ConsumerWidget {
  const RevenueCardWidget({super.key});

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
            Text('Revenue by Client', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 16),
            ...data.revenueData.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: r.avatarColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        r.name.split(' ').map((e) => e[0]).join(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: r.avatarColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        )),
                        Text(r.role, style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        )),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${_formatAmount(r.amount)}', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      )),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            r.isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            size: 14,
                            color: r.isPositive ? AppColors.success : AppColors.error,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${r.change.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: r.isPositive ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            )),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms).slideY(begin: 0.1);
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}k';
    return amount.toStringAsFixed(0);
  }
}
