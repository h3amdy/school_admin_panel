import 'package:flutter/material.dart';

/// ويدجت رسم مخصص لعرض شريط ترددات الصوت
class AmplitudePainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  AmplitudePainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    if (amplitudes.isEmpty) return;

    final double barWidth = 4.0;
    final double barSpacing = 1.5 * 2;
    final double totalWidth = (barWidth + barSpacing) * amplitudes.length;
    double startX = (size.width - totalWidth) / 2;

    for (var amp in amplitudes) {
      final double barHeight =
          (amp * (size.height - 2)).clamp(2.0, size.height);
      final double yCenter = size.height / 2;

      canvas.drawLine(
        Offset(startX + barWidth / 2, yCenter - barHeight / 2),
        Offset(startX + barWidth / 2, yCenter + barHeight / 2),
        paint,
      );
      startX += barWidth + barSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant AmplitudePainter oldDelegate) {
    // إعادة الرسم فقط إذا تغيرت قائمة الترددات
    return oldDelegate.amplitudes != amplitudes;
  }
}