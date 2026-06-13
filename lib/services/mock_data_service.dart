import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/dashboard_models.dart';

class MockDataService {
  MockDataService._();

  static double _vary(double value, double maxPct) {
    final r = value * maxPct * 2.0 * (0.5 - (DateTime.now().microsecondsSinceEpoch % 1000) / 1000);
    final result = value + r;
    final lo = value < 0 ? result * 1.5 : 0.0;
    final hi = value < 0 ? result * 0.5 : value * 3;
    return result.clamp(lo, hi).toDouble();
  }

  static DashboardData fluctuate(DashboardData current) {
    final seed = current.animationSeed + 1;
    return DashboardData(
      animationSeed: seed,

      newUsers: current.newUsers.map((p) => ChartPoint(x: p.x, y: _vary(p.y, 0.08), label: p.label)).toList(),
      lostUsers: current.lostUsers.map((p) => ChartPoint(x: p.x, y: _vary(p.y, 0.10), label: p.label)).toList(),

      donutStats: current.donutStats.map((d) => DonutData(
        label: d.label, value: _vary(d.value, 0.05).clamp(5, 100), color: d.color,
      )).toList(),

      radarData: current.radarData.map((r) => RadarData(
        label: r.label, values: r.values.map((v) => _vary(v, 0.06).clamp(10.0, 100.0) as double).toList(),
      )).toList(),

      progressBars: current.progressBars.map((p) => ProgressBarData(
        label: p.label,
        progress: _vary(p.progress, 0.08).clamp(0.05, 0.98),
        gradient: p.gradient,
        suffix: '${(_vary(p.progress * 100, 0.08).clamp(5, 98)).toStringAsFixed(0)}%',
      )).toList(),

      areaNewUsers: current.areaNewUsers.map((p) => ChartPoint(x: p.x, y: _vary(p.y, 0.06))).toList(),
      areaReturning: current.areaReturning.map((p) => ChartPoint(x: p.x, y: _vary(p.y, 0.07))).toList(),
      areaViews: current.areaViews.map((p) => ChartPoint(x: p.x, y: _vary(p.y, 0.05))).toList(),

      kpiCards: current.kpiCards.map((k) => KpiCardData(
        title: k.title, value: _vary(k.value, 0.04), change: _vary(k.change, 0.15),
        icon: k.icon, color: k.color, prefix: k.prefix,
      )).toList(),

      waveStats: WaveStats(
        likes: _vary(current.waveStats.likes.toDouble(), 0.06).round(),
        views: _vary(current.waveStats.views.toDouble(), 0.04).round(),
        engagement: _vary(current.waveStats.engagement, 0.08).clamp(0.5, 25),
      ),

      tableData: current.tableData.map((t) => TableRowData(
        category: t.category, quantity: _vary(t.quantity.toDouble(), 0.05).round(),
        percentage: _vary(t.percentage, 0.06).clamp(0.5, 50), color: t.color,
      )).toList(),

      revenueData: current.revenueData.map((r) => RevenueData(
        name: r.name, role: r.role, amount: _vary(r.amount, 0.06),
        change: _vary(r.change, 0.2), isPositive: r.isPositive, avatarColor: r.avatarColor,
      )).toList(),

      storageData: current.storageData.map((s) => StorageData(
        usedGB: _vary(s.usedGB, 0.04).clamp(0.1, s.totalGB * 0.95),
        totalGB: s.totalGB, label: s.label,
      )).toList(),

      speedData: SpeedData(
        currentMbps: _vary(current.speedData.currentMbps, 0.10).clamp(10, current.speedData.maxMbps),
        maxMbps: current.speedData.maxMbps,
        uploadMbps: _vary(current.speedData.uploadMbps, 0.12).clamp(5, 500),
      ),

      batteryData: BatteryData(
        percentage: _vary(current.batteryData.percentage, 0.03).clamp(2, 100).roundToDouble(),
        isCharging: current.batteryData.isCharging,
      ),

      directSales: _vary(current.directSales, 0.04).clamp(20, 80),
      resellerSales: _vary(current.resellerSales, 0.04).clamp(20, 80),

      bottomKpis: current.bottomKpis,

      circularProgressValues: current.circularProgressValues.map((v) =>
        _vary(v, 0.06).clamp(5.0, 95.0) as double
      ).toList(),
    );
  }

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

      // ── Crypto Prices (Yearly Performance) ────────────────────────
      bottomKpis: [
        BottomKpi(label: 'Bitcoin', value: 67520, change: 3.2, icon: Icons.currency_bitcoin, isPositive: true),
        BottomKpi(label: 'Ethereum', value: 3480, change: -1.5, icon: Icons.monetization_on_outlined, isPositive: false),
        BottomKpi(label: 'Solana', value: 142.50, change: 5.8, icon: Icons.circle_outlined, isPositive: true),
        BottomKpi(label: 'XRP', value: 0.52, change: -0.3, icon: Icons.water_drop_outlined, isPositive: false),
      ],

      circularProgressValues: [30, 50, 80],
    );
  }
}
