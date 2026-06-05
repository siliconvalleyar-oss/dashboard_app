import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/dashboard_models.dart';

class MockDataService {
  MockDataService._();

  static DashboardData generate() {
    final now = DateTime.now();

    return DashboardData(
      // ── Line Chart Data ───────────────────────────────────────────
      newUsers: List.generate(
        12,
        (i) => ChartPoint(
          x: i.toDouble(),
          y: [120, 180, 150, 220, 280, 250, 340, 310, 390, 360, 420, 480][i].toDouble(),
          label: '${DateTime(now.year, i + 1, 1).month}/${now.year}',
        ),
      ),
      lostUsers: List.generate(
        12,
        (i) => ChartPoint(
          x: i.toDouble(),
          y: [40, 35, 55, 45, 60, 50, 70, 65, 80, 75, 85, 90][i].toDouble(),
          label: '${DateTime(now.year, i + 1, 1).month}/${now.year}',
        ),
      ),

      // ── Donut Data ────────────────────────────────────────────────
      donutStats: [
        DonutData(label: 'New Users', value: 45, color: const Color(0xFF4EF2FF)),
        DonutData(label: 'Page Views', value: 30, color: const Color(0xFFB05CFF)),
        DonutData(label: 'Returning Users', value: 25, color: const Color(0xFFFFC14D)),
      ],

      // ── Radar Data ────────────────────────────────────────────────
      radarData: [
        RadarData(
          label: 'Sector A',
          values: [80, 70, 85, 60, 75],
        ),
        RadarData(
          label: 'Sector B',
          values: [60, 85, 55, 80, 70],
        ),
        RadarData(
          label: 'Sector C',
          values: [45, 60, 75, 70, 85],
        ),
      ],

      // ── Progress Bars ─────────────────────────────────────────────
      progressBars: [
        ProgressBarData(
          label: 'New Users',
          progress: 0.75,
          gradient: AppColors.cyanPurple,
          suffix: '75%',
        ),
        ProgressBarData(
          label: 'Revenue',
          progress: 0.60,
          gradient: AppColors.orangePink,
          suffix: '60%',
        ),
        ProgressBarData(
          label: 'Sales',
          progress: 0.88,
          gradient: AppColors.greenBlue,
          suffix: '88%',
        ),
        ProgressBarData(
          label: 'Engagement',
          progress: 0.42,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A65), Color(0xFFFF5EA8)],
          ),
          suffix: '42%',
        ),
      ],

      // ── Area Chart Data ───────────────────────────────────────────
      areaNewUsers: List.generate(
        12,
        (i) => ChartPoint(
          x: i.toDouble(),
          y: [200, 280, 250, 320, 380, 350, 440, 410, 490, 460, 520, 580][i].toDouble(),
        ),
      ),
      areaReturning: List.generate(
        12,
        (i) => ChartPoint(
          x: i.toDouble(),
          y: [100, 140, 120, 160, 190, 170, 220, 200, 240, 230, 260, 290][i].toDouble(),
        ),
      ),
      areaViews: List.generate(
        12,
        (i) => ChartPoint(
          x: i.toDouble(),
          y: [300, 420, 380, 480, 570, 520, 660, 610, 730, 690, 780, 870][i].toDouble(),
        ),
      ),

      // ── KPI Cards ─────────────────────────────────────────────────
      kpiCards: [
        KpiCardData(
          title: 'Followers',
          value: 28450,
          change: 12.5,
          icon: Icons.people_alt_outlined,
          color: const Color(0xFF4EF2FF),
        ),
        KpiCardData(
          title: 'Sales',
          value: 15680,
          change: -3.2,
          icon: Icons.trending_up_rounded,
          color: const Color(0xFF64FFC8),
          prefix: '\$',
        ),
        KpiCardData(
          title: 'Customers',
          value: 8930,
          change: 8.7,
          icon: Icons.person_outline_rounded,
          color: const Color(0xFFFFC14D),
        ),
        KpiCardData(
          title: 'Revenue',
          value: 248500,
          change: 15.3,
          icon: Icons.account_balance_wallet_outlined,
          color: const Color(0xFFB05CFF),
          prefix: '\$',
        ),
      ],

      // ── Wave Stats ────────────────────────────────────────────────
      waveStats: WaveStats(
        likes: 8450,
        views: 124500,
        engagement: 6.8,
      ),

      // ── Table Data ────────────────────────────────────────────────
      tableData: [
        TableRowData(category: 'Social Media', quantity: 45230, percentage: 28.5, color: const Color(0xFF4EF2FF)),
        TableRowData(category: 'Email Campaign', quantity: 32100, percentage: 20.2, color: const Color(0xFFB05CFF)),
        TableRowData(category: 'Search Engine', quantity: 28750, percentage: 18.1, color: const Color(0xFFFFC14D)),
        TableRowData(category: 'Direct Traffic', quantity: 22500, percentage: 14.2, color: const Color(0xFF64FFC8)),
        TableRowData(category: 'Referral Links', quantity: 18900, percentage: 11.9, color: const Color(0xFFFF5EA8)),
        TableRowData(category: 'Other Sources', quantity: 11230, percentage: 7.1, color: const Color(0xFFFF8A65)),
      ],

      // ── Revenue Data ──────────────────────────────────────────────
      revenueData: [
        RevenueData(name: 'Sarah Johnson', role: 'Enterprise', amount: 28450, change: 12.5, isPositive: true, avatarColor: const Color(0xFF4EF2FF)),
        RevenueData(name: 'Michael Chen', role: 'Startup', amount: 18600, change: -4.2, isPositive: false, avatarColor: const Color(0xFFB05CFF)),
        RevenueData(name: 'Emily Davis', role: 'Agency', amount: 32200, change: 8.7, isPositive: true, avatarColor: const Color(0xFFFFC14D)),
        RevenueData(name: 'James Wilson', role: 'Enterprise', amount: 15800, change: 3.1, isPositive: true, avatarColor: const Color(0xFF64FFC8)),
      ],

      // ── Storage ───────────────────────────────────────────────────
      storageData: [
        StorageData(usedGB: 4.2, totalGB: 10, label: 'Documents'),
        StorageData(usedGB: 128, totalGB: 500, label: 'Media'),
        StorageData(usedGB: 0.6, totalGB: 1, label: 'Backups'),
      ],

      // ── Speed ─────────────────────────────────────────────────────
      speedData: SpeedData(
        currentMbps: 245,
        maxMbps: 1000,
        uploadMbps: 85,
      ),

      // ── Battery ───────────────────────────────────────────────────
      batteryData: BatteryData(
        percentage: 78,
        isCharging: true,
      ),

      // ── Sales Rings ───────────────────────────────────────────────
      directSales: 65,
      resellerSales: 35,

      // ── Bottom KPIs ───────────────────────────────────────────────
      bottomKpis: [
        BottomKpi(label: 'Earnings', value: 428500, change: 15.3, icon: Icons.trending_up_rounded, isPositive: true),
        BottomKpi(label: 'Sales', value: 156800, change: -2.1, icon: Icons.trending_down_rounded, isPositive: false),
        BottomKpi(label: 'Trade', value: 89300, change: 8.7, icon: Icons.trending_up_rounded, isPositive: true),
        BottomKpi(label: 'Yearly', value: 2450000, change: 22.4, icon: Icons.trending_up_rounded, isPositive: true),
      ],
    );
  }
}
