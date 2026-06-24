import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// SpectraSense icon: glasses inside radar rings with a detection ping.
/// Drawn in code so it scales crisply and needs no asset.
class SpectraLogo extends StatelessWidget {
  final double size;
  const SpectraLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final c = Offset(w / 2, w / 2);

    // rounded square background
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, w),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(bgRect, Paint()..color = AppTheme.primaryGreen);

    // radar rings
    final rings = [
      [0.40, AppTheme.greenLight, 0.35],
      [0.31, AppTheme.greenSoft, 0.55],
      [0.22, AppTheme.greenSoft, 0.75],
    ];
    for (final r in rings) {
      canvas.drawCircle(
        c,
        w * (r[0] as double),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.008
          ..color = (r[1] as Color).withOpacity(r[2] as double),
      );
    }

    // glasses lenses
    final lensPaint = Paint()..color = Colors.white;
    final lensW = w * 0.16;
    final lensH = w * 0.12;
    final gap = w * 0.06;
    final lensY = c.dy - lensH / 2;

    final left = RRect.fromRectAndRadius(
      Rect.fromLTWH(c.dx - gap / 2 - lensW, lensY, lensW, lensH),
      Radius.circular(w * 0.045),
    );
    final right = RRect.fromRectAndRadius(
      Rect.fromLTWH(c.dx + gap / 2, lensY, lensW, lensH),
      Radius.circular(w * 0.045),
    );
    canvas.drawRRect(left, lensPaint);
    canvas.drawRRect(right, lensPaint);

    // bridge
    final bridge = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(c.dx - gap / 2, c.dy - lensH * 0.1),
      Offset(c.dx + gap / 2, c.dy - lensH * 0.1),
      bridge,
    );

    // lens pupils (green)
    final pupil = Paint()..color = AppTheme.primaryGreen;
    canvas.drawCircle(
        Offset(c.dx - gap / 2 - lensW / 2, c.dy), w * 0.024, pupil);
    canvas.drawCircle(
        Offset(c.dx + gap / 2 + lensW / 2, c.dy), w * 0.024, pupil);

    // center ping
    canvas.drawCircle(c, w * 0.013, Paint()..color = AppTheme.ping);
    canvas.drawCircle(
      c,
      w * 0.03,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.005
        ..color = AppTheme.ping.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
