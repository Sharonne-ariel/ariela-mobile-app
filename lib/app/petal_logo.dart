import 'package:flutter/material.dart';
import 'theme.dart';

/// ARIELA petal logo — three soft teardrop petals meeting at a center.
///
/// Use this widget anywhere the brand mark is needed.
/// Pass a [size] to scale it; defaults to 96px.
class PetalLogo extends StatelessWidget {
  const PetalLogo({
    super.key,
    this.size = 96,
    this.centerColor = ArielaTheme.surfaceBg,
  });

  /// The width and height of the logo (it's always square).
  final double size;

  /// The color of the small dot at the center.
  /// Should match whatever background the logo sits on.
  final Color centerColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PetalPainter(centerColor: centerColor),
      ),
    );
  }
}

class _PetalPainter extends CustomPainter {
  _PetalPainter({required this.centerColor});

  final Color centerColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale path coordinates from a 100x100 design grid to the actual size.
    final scaleX = size.width / 100;
    final scaleY = size.height / 100;

    // Petal 1 — top, lavender 600
    final topPetal = Path()
      ..moveTo(50 * scaleX, 12 * scaleY)
      ..cubicTo(60 * scaleX, 24 * scaleY, 60 * scaleX, 38 * scaleY, 50 * scaleX, 50 * scaleY)
      ..cubicTo(40 * scaleX, 38 * scaleY, 40 * scaleX, 24 * scaleY, 50 * scaleX, 12 * scaleY)
      ..close();

    // Petal 2 — bottom-left, lavender 400
    final leftPetal = Path()
      ..moveTo(18 * scaleX, 68 * scaleY)
      ..cubicTo(30 * scaleX, 62 * scaleY, 44 * scaleX, 60 * scaleY, 50 * scaleX, 50 * scaleY)
      ..cubicTo(38 * scaleX, 50 * scaleY, 24 * scaleX, 56 * scaleY, 18 * scaleX, 68 * scaleY)
      ..close();

    // Petal 3 — bottom-right, pink 600
    final rightPetal = Path()
      ..moveTo(82 * scaleX, 68 * scaleY)
      ..cubicTo(70 * scaleX, 62 * scaleY, 56 * scaleX, 60 * scaleY, 50 * scaleX, 50 * scaleY)
      ..cubicTo(62 * scaleX, 50 * scaleY, 76 * scaleX, 56 * scaleY, 82 * scaleX, 68 * scaleY)
      ..close();

    canvas.drawPath(topPetal, Paint()..color = ArielaTheme.lavender600);
    canvas.drawPath(leftPetal, Paint()..color = ArielaTheme.lavender400);
    canvas.drawPath(rightPetal, Paint()..color = ArielaTheme.pink600);

    // Center dot — matches background
    canvas.drawCircle(
      Offset(50 * scaleX, 50 * scaleY),
      4 * scaleX,
      Paint()..color = centerColor,
    );
  }

  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) {
    return oldDelegate.centerColor != centerColor;
  }
}