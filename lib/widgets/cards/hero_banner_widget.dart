import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';

class HeroMarketingBannerWidget extends StatelessWidget {
  const HeroMarketingBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Card(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [const Color(0xFFF0F0FF), const Color(0xFFE8F0FE)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Increase Your',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 4),
                  Text(
                    'Audience',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(begin: -0.1),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.cyanPurple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyanPurple.colors.first.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Learn More →',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideX(begin: -0.1),
                ],
              ),
            ),
            // Animated curves
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: _HeroCurvePainter(isDark: isDark),
              ),
            ).animate().scale(duration: 800.ms, delay: 300.ms, curve: Curves.easeOutBack),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.15);
  }
}

class _HeroCurvePainter extends CustomPainter {
  final bool isDark;

  _HeroCurvePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..shader = AppColors.cyanPurple.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.8);
    path1.quadraticBezierTo(size.width * 0.3, -10, size.width, size.height * 0.3);
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..shader = AppColors.orangePink.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.6);
    canvas.drawPath(path2, paint2);

    // Glow dots
    final dotPaint = Paint()
      ..shader = AppColors.cyanPurple.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.35), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
