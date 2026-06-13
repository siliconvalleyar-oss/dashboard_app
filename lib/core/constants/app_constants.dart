class AppConstants {
  AppConstants._();

  // ── Layout ─────────────────────────────────────────────────────────
  static const double sidebarWidth = 260;
  static const double sidebarCollapsedWidth = 72;
  static const double headerHeight = 72;
  static const double bottomNavHeight = 64;

  // ── Grid ───────────────────────────────────────────────────────────
  static const int gridColumnsDesktop = 4;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsMobile = 1;
  static const double gridSpacing = 16;
  static const double gridRunSpacing = 16;

  // ── Animation ──────────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);

  // ── Chart ──────────────────────────────────────────────────────────
  static const double chartAnimationDuration = 1.5;
  static const int defaultChartCurveSmoothness = 3;

  // ── Sidebar Menu Items ─────────────────────────────────────────────
  static const List<Map<String, dynamic>> sidebarItems = [
    {'icon': 'dashboard', 'label': 'Dashboard', 'route': '/dashboard'},
    {'icon': 'analytics', 'label': 'Analytics', 'route': '/analytics'},
    {'icon': 'campaign', 'label': 'Marketing', 'route': '/marketing'},
    {'icon': 'group', 'label': 'Customers', 'route': '/customers'},
    {'icon': 'trending_up', 'label': 'Sales', 'route': '/sales'},
    {'icon': 'description', 'label': 'Reports', 'route': '/reports'},
    {'icon': 'account_balance', 'label': 'Finance', 'route': '/finance'},
    {'icon': 'cloud', 'label': 'Storage', 'route': '/storage'},
    {'icon': 'notifications', 'label': 'Notifications', 'route': '/notifications'},
    {'icon': 'settings', 'label': 'Settings', 'route': '/settings'},
  ];
}
