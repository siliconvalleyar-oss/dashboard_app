import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_providers.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final searchQuery = ref.watch(searchQueryProvider);

    return Container(
      height: AppBar().preferredSize.height + 8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSecondary : AppColors.lightCardPrimary,
        border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder, width: 1)),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextField(
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search anything...',
                prefixIcon: Icon(Icons.search_rounded, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary, size: 20),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, size: 18, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                        onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                      )
                    : null,
              ),
            ),
          ),
        ),
        const Spacer(),
        _buildOnlineIndicator(context),
        const SizedBox(width: 8),
        _buildLanguageSelector(context, isDark),
        const SizedBox(width: 4),
        _buildThemeToggle(context, ref, isDark),
        const SizedBox(width: 4),
        _buildNotificationButton(context, isDark),
        const SizedBox(width: 12),
        _buildUserAvatar(context),
      ]),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }

  Widget _buildOnlineIndicator(BuildContext context) {
    return Tooltip(
      message: 'Online',
      child: Container(width: 8, height: 8, decoration: BoxDecoration(
        color: AppColors.success, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.5), blurRadius: 6)],
      )),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.darkCardPrimary : AppColors.lightCardPrimary,
      onSelected: (lang) {},
      itemBuilder: (context) => [
        _langItem('🇺🇸  English', 'en'),
        _langItem('🇪🇸  Español', 'es'),
        _langItem('🇫🇷  Français', 'fr'),
        _langItem('🇩🇪  Deutsch', 'de'),
      ],
      child: _headerIconButton(context, Icons.translate_rounded, isDark),
    );
  }

  PopupMenuItem<String> _langItem(String text, String value) {
    return PopupMenuItem(value: value, child: Text(text, style: const TextStyle(fontSize: 14)));
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref, bool isDark) {
    return _headerIconButton(
      context, isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, isDark,
      onPressed: () => ref.read(themeProvider.notifier).toggle(),
    );
  }

  Widget _buildNotificationButton(BuildContext context, bool isDark) {
    return Stack(clipBehavior: Clip.none, children: [
      _headerIconButton(context, Icons.notifications_outlined, isDark),
      Positioned(
        top: 4, right: 4,
        child: Container(width: 18, height: 18, decoration: BoxDecoration(
          gradient: AppColors.orangePink, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.4), blurRadius: 6)],
        ), child: const Center(child: Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)))),
      ),
    ]);
  }

  Widget _buildUserAvatar(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(gradient: AppColors.orangePink, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.orangePink.colors.first.withOpacity(0.3), blurRadius: 8)],
      ),
      child: const Center(child: Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
    );
  }

  Widget _headerIconButton(BuildContext context, IconData icon, bool isDark, {VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(width: 40, height: 40, decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? const Color(0xFF1D1D21) : const Color(0xFFF0F2F5),
        ), child: Icon(icon, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
      ),
    );
  }
}
