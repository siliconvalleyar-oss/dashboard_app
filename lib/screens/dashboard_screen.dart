import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../widgets/charts/line_chart_widget.dart';
import '../widgets/charts/tracking_dashboard_widget.dart';
import '../widgets/charts/radar_chart_widget.dart';
import '../widgets/charts/area_chart_widget.dart';
import '../widgets/charts/wave_chart_widget.dart';
import '../widgets/charts/venn_diagram_widget.dart';
import '../widgets/cards/progress_bars_widget.dart';
import '../widgets/cards/kpi_cards_widget.dart';
import '../widgets/cards/circular_progress_widget.dart';
import '../widgets/cards/storage_monitor_widget.dart';
import '../widgets/cards/speed_monitor_widget.dart';
import '../widgets/cards/battery_widget.dart';
import '../widgets/cards/overview_table_widget.dart';
import '../widgets/cards/revenue_card_widget.dart';
import '../widgets/cards/sales_rings_widget.dart';
import '../widgets/cards/hero_banner_widget.dart';
import '../widgets/cards/bottom_kpi_section_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary,
      body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: _buildHeader(context, isDark),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: KpiCardsWidget(),
              ),
            ),
            // Wrap widgets in SliverToBoxAdapter since SliverMasonryGrid may not be available
            ..._gridWidgets.map((entry) => SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: context.cardSpacing, left: 24, right: 24),
                child: SizedBox(height: entry.height, child: entry.widget),
              ),
            )),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final isMobile = context.isMobile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: context.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              const SizedBox(height: 4),
              Text('Welcome back, Alex! Here\'s your analytics overview.',
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
            ],
          ),
        ),
        if (!isMobile)
          Row(children: [
            _quickStat('+12.5%', 'vs last month', AppColors.success, isDark),
            const SizedBox(width: 12),
            _quickStat('4,520', 'active users', AppColors.info, isDark),
          ]),
      ],
    );
  }

  Widget _quickStat(String value, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardPrimary : AppColors.lightCardPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
      ]),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }

  static const double _baseHeight = 320;

  static final List<_GridEntry> _gridWidgets = [
    _GridEntry(LineChartAnalyticsWidget(), _baseHeight),
    _GridEntry(TrackingDashboardWidget(), 420),
    _GridEntry(RadarChartWidget(), _baseHeight + 40),
    _GridEntry(ProgressBarsWidget(), 280),
    _GridEntry(AreaAnalyticsChartWidget(), _baseHeight),
    _GridEntry(WaveStatisticsWidget(), 260),
    _GridEntry(VennDiagramWidget(), 280),
    _GridEntry(CircularProgressWidget(), 270),
    _GridEntry(StorageMonitorWidget(), 260),
    _GridEntry(SpeedMonitorWidget(), 290),
    _GridEntry(BatteryWidget(), 280),
    _GridEntry(OverviewTableWidget(), 420),
    _GridEntry(RevenueCardWidget(), 370),
    _GridEntry(SalesRingsWidget(), 280),
    _GridEntry(HeroMarketingBannerWidget(), 200),
    _GridEntry(BottomKpiSectionWidget(), 280),
  ];
}

class _GridEntry {
  final Widget widget;
  final double height;
  const _GridEntry(this.widget, this.height);
}
