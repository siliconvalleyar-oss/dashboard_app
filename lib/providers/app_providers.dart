import 'dart:async';
import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../services/mock_data_service.dart';
import '../services/live_data_service.dart';
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
  late Timer _mockTimer;
  late Timer _batteryTimer;
  late Timer _pingTimer;
  late Timer _cryptoTimer;

  DashboardNotifier() : super(MockDataService.generate()) {
    _mockTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      fluctuate();
    });
    _batteryTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateBattery();
    });
    _pingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _updatePing();
    });
    _cryptoTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateCrypto();
    });
    _updateBattery();
    _updatePing();
    _updateCrypto();
  }

  void fluctuate() {
    state = MockDataService.fluctuate(state);
  }

  void refresh() {
    state = MockDataService.generate();
  }

  Future<void> _updateBattery() async {
    final battery = await LiveDataService.readBattery();
    state = state.copyWith(batteryData: battery);
  }

  Future<void> _updatePing() async {
    final ping = await LiveDataService.measurePingMs();
    final upload = await LiveDataService.measureUploadMbps();
    final current = state.speedData;
    state = state.copyWith(speedData: SpeedData(
      currentMbps: ping > 0 ? (100.0 / ping).clamp(1, 100) : current.currentMbps,
      uploadMbps: upload > 0 ? upload : current.uploadMbps,
      maxMbps: current.maxMbps,
    ));
  }

  Future<void> _updateCrypto() async {
    final prices = await LiveDataService.fetchCryptoPrices();
    if (prices.isNotEmpty) {
      state = state.copyWith(bottomKpis: prices);
    }
  }

  @override
  void dispose() {
    _mockTimer.cancel();
    _batteryTimer.cancel();
    _pingTimer.cancel();
    _cryptoTimer.cancel();
    super.dispose();
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
