import 'dart:math';

import 'package:flutter/material.dart';

/// Class that is used inside [_RenderFeedbackConfirmationIdicator].
///
/// Discribes the how to paint animated confirm icon.
class ConfirmIcon {
  void paint(Canvas canvas, double shortestSide, Offset position, double delta) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(delta.clamp(0, 1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = shortestSide / 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final size = Size(shortestSide / 2, shortestSide);

    final path = Path()
      ..moveTo(size.width * 0.29, size.height * 1.14)
      ..cubicTo(size.width * 0.29, size.height * 1.14, size.width * 1.29, size.height * 1.14, size.width * 1.29,
          size.height * 1.14)
      ..cubicTo(size.width * 1.29, size.height * 1.14, size.width * 1.29, size.height * 0.14, size.width * 1.29,
          size.height * 0.14);

    final rotationMatrix4 = Matrix4.identity()
      ..translate(position.dx - size.width, position.dy - size.height / 1.5)
      ..translate(size.width / 1.5, size.height / 1.5)
      ..multiply(Matrix4.rotationZ(pi / 4 * delta))
      ..translate(-size.width / 1.25, -size.height / 1.25);

    canvas.drawPath(path.transform(rotationMatrix4.storage), paint);
  }
}
