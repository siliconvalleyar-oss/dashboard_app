import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/dashboard_models.dart';
import '../services/mock_data_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Theme Provider ───────────────────────────────────────────────────
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setDark() => state = ThemeMode.dark;
  void setLight() => state = ThemeMode.light;
  bool get isDark => state == ThemeMode.dark;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// ── Dashboard Data Provider ──────────────────────────────────────────
class DashboardNotifier extends StateNotifier<DashboardData> {
  DashboardNotifier() : super(MockDataService.generate());

  void refresh() {
    state = MockDataService.generate();
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardData>((ref) {
  return DashboardNotifier();
});

// ── Sidebar State ────────────────────────────────────────────────────
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

// ── Search Query ─────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Active Route ─────────────────────────────────────────────────────
final activeRouteProvider = StateProvider<String>((ref) => '/dashboard');
