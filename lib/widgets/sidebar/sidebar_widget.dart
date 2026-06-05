import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final activeRoute = ref.watch(activeRouteProvider);
    final isDark = context.isDark;

    return AnimatedContainer(
      duration: AppConstants.animNormal,
      curve: Curves.easeInOutCubic,
      width: collapsed ? AppConstants.sidebarCollapsedWidth : AppConstants.sidebarWidth,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSecondary : AppColors.lightCardPrimary,
        border: Border(right: BorderSide(color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder, width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(2, 0))],
      ),
      child: Column(children: [
        _buildLogo(context, collapsed),
        const Divider(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 8 : 12, vertical: 8),
            children: AppConstants.sidebarItems.map((item) {
              final route = item['route'] as String;
              final isActive = activeRoute == route;
              return _SidebarItem(
                icon: item['icon'] as String, label: item['label'] as String,
                route: route, isActive: isActive, collapsed: collapsed,
                onTap: () => ref.read(activeRouteProvider.notifier).state = route,
              );
            }).toList(),
          ),
        ),
        const Divider(),
        _buildCollapseButton(context, collapsed, ref),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _buildLogo(BuildContext context, bool collapsed) {
    final isDark = context.isDark;
    return Container(
      height: AppConstants.headerHeight,
      padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 20),
      child: Row(
        mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppColors.cyanPurple, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 20))),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Text('SaludSync', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          ],
        ],
      ),
    );
  }

  Widget _buildCollapseButton(BuildContext context, bool collapsed, WidgetRef ref) {
    return IconButton(
      icon: AnimatedRotation(turns: collapsed ? 0.5 : 0, duration: AppConstants.animNormal,
        child: Icon(Icons.chevron_left_rounded, color: context.isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
      onPressed: () => ref.read(sidebarCollapsedProvider.notifier).state = !collapsed,
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String icon; final String label; final String route;
  final bool isActive; final bool collapsed; final VoidCallback onTap;
  const _SidebarItem({required this.icon, required this.label, required this.route, required this.isActive, required this.collapsed, required this.onTap});

  IconData _getIcon() {
    switch (icon) {
      case 'dashboard': return Icons.dashboard_rounded;
      case 'analytics': return Icons.analytics_rounded;
      case 'campaign': return Icons.campaign_rounded;
      case 'group': return Icons.group_rounded;
      case 'trending_up': return Icons.trending_up_rounded;
      case 'description': return Icons.description_rounded;
      case 'account_balance': return Icons.account_balance_rounded;
      case 'cloud': return Icons.cloud_rounded;
      case 'notifications': return Icons.notifications_rounded;
      case 'settings': return Icons.settings_rounded;
      default: return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final iconData = _getIcon();

    return Padding(
      padding: EdgeInsets.only(bottom: collapsed ? 4 : 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppConstants.animFast,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 16, vertical: collapsed ? 12 : 10),
            decoration: BoxDecoration(
              color: isActive ? (isDark ? const Color(0xFF2A2A35) : const Color(0xFFF0F0FF)) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive ? Border.all(color: (isDark ? AppColors.cyanPurple : AppColors.orangePink).colors.first.withOpacity(0.2), width: 1) : null,
            ),
            child: Row(
              mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => (isActive ? AppColors.cyanPurple : LinearGradient(colors: isDark ? [AppColors.darkTextSecondary, AppColors.darkTextSecondary] : [AppColors.lightTextSecondary, AppColors.lightTextSecondary])).createShader(bounds),
                  child: Icon(iconData, size: 22, color: Colors.white),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 14),
                  Text(label, style: context.textTheme.bodyLarge?.copyWith(
                    color: isActive ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  )),
                  const Spacer(),
                  if (isActive) Container(width: 6, height: 6, decoration: BoxDecoration(gradient: AppColors.cyanPurple, shape: BoxShape.circle)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
