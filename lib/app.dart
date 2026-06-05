import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/extensions/context_extensions.dart';
import 'providers/app_providers.dart';
import 'widgets/sidebar/sidebar_widget.dart';
import 'widgets/header/header_widget.dart';
import 'screens/dashboard_screen.dart';

class SaludSyncApp extends ConsumerWidget {
  const SaludSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'SaludSync — Analytics Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with SingleTickerProviderStateMixin {
  late AnimationController _sidebarAnimController;

  @override
  void initState() {
    super.initState();
    _sidebarAnimController = AnimationController(
      vsync: this,
      duration: AppConstants.animNormal,
    );
  }

  @override
  void dispose() {
    _sidebarAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final isDark = context.isDark;

    // Sync animation with state
    if (collapsed && _sidebarAnimController.status != AnimationStatus.forward) {
      _sidebarAnimController.forward();
    } else if (!collapsed && _sidebarAnimController.status != AnimationStatus.reverse) {
      _sidebarAnimController.reverse();
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (context.isMobile) {
            return _buildMobileLayout(context, isDark);
          }
          return _buildDesktopLayout(context, isDark, collapsed);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark, bool collapsed) {
    return Row(
      children: [
        // ── Sidebar ────────────────────────────────────────────────
        const SidebarWidget(),

        // ── Main Content ────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              const HeaderWidget(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppConstants.animNormal,
                  child: _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final activeRoute = ref.watch(activeRouteProvider);

    switch (activeRoute) {
      case '/dashboard':
        return const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }
}
