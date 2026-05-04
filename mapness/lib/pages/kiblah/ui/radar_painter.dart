import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  RadarPainter(this.radarShader, this.updateTime);
  final Shader radarShader;
  final double updateTime;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = radarShader;
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => updateTime != oldDelegate.updateTime;
}
