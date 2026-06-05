import 'package:flutter/material.dart';

// ── Chart Data Models ────────────────────────────────────────────────
class ChartPoint {
  final double x;
  final double y;
  final String? label;

  ChartPoint({required this.x, required this.y, this.label});
}

class LineChartData {
  final String label;
  final List<ChartPoint> points;
  final Color color;

  LineChartData({required this.label, required this.points, required this.color});
}

class DonutData {
  final String label;
  final double value;
  final Color color;

  DonutData({required this.label, required this.value, required this.color});
}

class RadarData {
  final String label;
  final List<double> values;

  RadarData({required this.label, required this.values});
}

class ProgressBarData {
  final String label;
  final double progress;
  final Gradient gradient;
  final String suffix;

  ProgressBarData({
    required this.label,
    required this.progress,
    required this.gradient,
    this.suffix = '',
  });
}

// ── KPI Models ───────────────────────────────────────────────────────
class KpiCardData {
  final String title;
  final double value;
  final double change;
  final IconData icon;
  final Color color;
  final String prefix;
  final String suffix;

  KpiCardData({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    this.prefix = '',
    this.suffix = '',
  });
}

class RevenueData {
  final String name;
  final String role;
  final double amount;
  final double change;
  final bool isPositive;
  final Color avatarColor;

  RevenueData({
    required this.name,
    required this.role,
    required this.amount,
    required this.change,
    required this.isPositive,
    required this.avatarColor,
  });
}

// ── Table Models ─────────────────────────────────────────────────────
class TableRowData {
  final String category;
  final int quantity;
  final double percentage;
  final Color color;

  TableRowData({
    required this.category,
    required this.quantity,
    required this.percentage,
    required this.color,
  });
}

// ── Storage & Speed Models ───────────────────────────────────────────
class StorageData {
  final double usedGB;
  final double totalGB;
  final String label;

  StorageData({required this.usedGB, required this.totalGB, required this.label});
}

class SpeedData {
  final double currentMbps;
  final double maxMbps;
  final double uploadMbps;

  SpeedData({required this.currentMbps, required this.maxMbps, required this.uploadMbps});
}

class BatteryData {
  final double percentage;
  final bool isCharging;

  BatteryData({required this.percentage, required this.isCharging});
}

// ── Wave Stats ───────────────────────────────────────────────────────
class WaveStats {
  final int likes;
  final int views;
  final double engagement;

  WaveStats({required this.likes, required this.views, required this.engagement});
}

// ── Bottom KPI ───────────────────────────────────────────────────────
class BottomKpi {
  final String label;
  final double value;
  final double change;
  final IconData icon;
  final bool isPositive;

  BottomKpi({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    required this.isPositive,
  });
}

// ── Dashboard Aggregate ──────────────────────────────────────────────
class DashboardData {
  final List<ChartPoint> newUsers;
  final List<ChartPoint> lostUsers;
  final List<DonutData> donutStats;
  final List<RadarData> radarData;
  final List<ProgressBarData> progressBars;
  final List<ChartPoint> areaNewUsers;
  final List<ChartPoint> areaReturning;
  final List<ChartPoint> areaViews;
  final List<KpiCardData> kpiCards;
  final WaveStats waveStats;
  final List<TableRowData> tableData;
  final List<RevenueData> revenueData;
  final List<StorageData> storageData;
  final SpeedData speedData;
  final BatteryData batteryData;
  final double directSales;
  final double resellerSales;
  final List<BottomKpi> bottomKpis;

  DashboardData({
    required this.newUsers,
    required this.lostUsers,
    required this.donutStats,
    required this.radarData,
    required this.progressBars,
    required this.areaNewUsers,
    required this.areaReturning,
    required this.areaViews,
    required this.kpiCards,
    required this.waveStats,
    required this.tableData,
    required this.revenueData,
    required this.storageData,
    required this.speedData,
    required this.batteryData,
    required this.directSales,
    required this.resellerSales,
    required this.bottomKpis,
  });
}
