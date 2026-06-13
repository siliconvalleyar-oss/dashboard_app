import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';

class VennDiagramWidget extends StatelessWidget {
  const VennDiagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audience Overlap', style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            )),
            const SizedBox(height: 4),
            Text('Marketing · Traffic · Sales', style: TextStyle(
              fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            )),
            const Expanded(
              child: Center(
                child: _VennPainterWidget(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chip('Marketing', const Color(0xFF4EF2FF)),
                const SizedBox(width: 16),
                _chip('Traffic', const Color(0xFFB05CFF)),
                const SizedBox(width: 16),
                _chip('Sales', const Color(0xFFFFC14D)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _chip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF909090))),
      ],
    );
  }
}

class _VennPainterWidget extends StatelessWidget {
  const _VennPainterWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 180),
      painter: _VennPainter(),
    ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack);
  }
}

class _VennPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    const radius = 60.0;
    const offset = 30.0;

    final paintA = Paint()
      ..shader = AppColors.cyanPurple.createShader(Rect.fromCircle(center: center - const Offset(offset, 0), radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center - const Offset(offset, 0), radius, paintA);

    final paintB = Paint()
      ..shader = AppColors.orangePink.createShader(Rect.fromCircle(center: center + const Offset(offset, 0), radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center + const Offset(offset, 0), radius, paintB);

    final paintC = Paint()
      ..shader = AppColors.greenBlue.createShader(Rect.fromCircle(center: center + const Offset(0, offset), radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center + const Offset(0, offset), radius, paintC);
  }

  @override
  bool shouldRepaint(covariant _VennPainter oldDelegate) => false;
}
