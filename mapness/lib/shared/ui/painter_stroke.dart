import 'package:flutter/material.dart';

class PainterStroke extends CustomPainter {
  PainterStroke({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final Paint p = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final innerRect = Rect.fromLTRB(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final outerRect = Offset.zero & size;

    final innerRoundedRect =
    RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius));
    final outerRoundedRect =
    RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));

    p.color = color;
    final borderPath = _calculateBorderPath(outerRoundedRect, innerRoundedRect);
    canvas.drawPath(borderPath, p);
  }

  Path _calculateBorderPath(RRect outerRect, RRect innerRect) {
    final outerRectPath = Path()..addRRect(outerRect);
    final innerRectPath = Path()..addRRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
