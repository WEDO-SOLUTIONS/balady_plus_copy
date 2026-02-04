import 'dart:math';
import 'package:flutter/material.dart';

class ScrollPainter extends CustomPainter {
  final double roughness;

  ScrollPainter({this.roughness = 1.7});
  static double topHeightForWidth(double width) => width * (_vbH / _vbW);

  static double topVisualBottomForWidth(double width) => topHeightForWidth(width) * (45.4004 / _vbH);

  static double strokeWidthForWidth(double width) => width * 0.008;

  static double maxRoughnessInset(double width, double roughness) => width * 0.02 * roughness;

  static double rollLeftForWidth(double width) => width * (23.5167 / _vbW);

  static double rollRightForWidth(double width) => width * (352.398 / _vbW);

  static const double _vbW = 375;
  static const double _vbH = 71;

  double _noise(int seed) {
    // детерминированный псевдошум [0..1]
    final x = sin(seed * 12.9898) * 43758.5453;
    return x - x.floor();
  }

  double _topHeight(Size s) => s.width * (_vbH / _vbW);
  double sx(Size s, double x) => x / _vbW * s.width;
  double sy(Size s, double y) => y / _vbH * _topHeight(s);

  Path? _cachedBodyPath;
  Size? _cachedSize;

  @override
  void paint(Canvas canvas, Size size) {
    final topVisualBottom = sy(size, 45.4004);

    // ==== COLORS ====
    final bodyPaint = Paint()..color = const Color(0xFFF9F7F3);
    final borderPaint = Paint()
      ..color = const Color(0xFFD6C2A2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.008;

    final rollPaint = Paint()..color = const Color(0xFFDAC6AE);
    final knobPaint = Paint()..color = const Color(0xFF523B32);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    // =====================================================
    // TOP SCROLL (SVG)
    // =====================================================

    final rollLeftX = sx(size, 23.5167);
    final rollRightX = sx(size, 352.398);

    final rollPath = Path()
      ..moveTo(rollLeftX, sy(size, 17.4004))
      ..lineTo(rollRightX, sy(size, 17.4004))
      ..cubicTo(
        sx(size, 352.783),
        sy(size, 17.4004),
        sx(size, 353.153),
        sy(size, 17.5536),
        sx(size, 353.426),
        sy(size, 17.8263),
      )
      ..cubicTo(
        sx(size, 360.923),
        sy(size, 25.3231),
        sx(size, 360.923),
        sy(size, 37.4777),
        sx(size, 353.426),
        sy(size, 44.9744),
      )
      ..cubicTo(
        sx(size, 353.153),
        sy(size, 45.2472),
        sx(size, 352.783),
        sy(size, 45.4004),
        rollRightX,
        sy(size, 45.4004),
      )
      ..lineTo(rollLeftX, sy(size, 45.4004))
      ..cubicTo(
        sx(size, 23.1836),
        sy(size, 45.4004),
        sx(size, 22.8618),
        sy(size, 45.2795),
        sx(size, 22.6112),
        sy(size, 45.0602),
      )
      ..cubicTo(
        sx(size, 14.3467),
        sy(size, 37.8287),
        sx(size, 14.3467),
        sy(size, 24.972),
        sx(size, 22.6112),
        sy(size, 17.7406),
      )
      ..close();

    canvas
      ..drawPath(rollPath, shadowPaint)
      ..drawPath(rollPath, rollPaint)
      // ---- ears
      ..drawPath(_leftKnob(size), knobPaint)
      ..drawPath(_rightKnob(size), knobPaint);

    // =====================================================
    // BODY (ALIGNED WITH SCROLL)
    // =====================================================

    final bodyHeight = size.height - topVisualBottom;
    final stroke = strokeWidthForWidth(size.width);
    final visualInset = stroke / 2 + maxRoughnessInset(size.width, roughness);

    final bodyRect = Rect.fromLTWH(
      rollLeftX + visualInset,
      topVisualBottom,
      rollRightX - rollLeftX - visualInset * 2,
      bodyHeight,
    );
    // final bodyPath = _tornRectPath(bodyRect);
    final bodyPath = _getBodyPath(bodyRect);

    canvas
      ..drawPath(
        bodyPath.shift(const Offset(0, 3)),
        Paint()
          ..color = Colors.black.withOpacity(0.05)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      )
      ..drawPath(bodyPath, bodyPaint)
      ..drawPath(bodyPath, borderPaint);
  }

  // =====================================================
  // BODY SHAPE
  // =====================================================

  Path _tornRectPath(Rect r) {
    final path = Path()
      ..moveTo(r.left, r.top)
      ..lineTo(r.right, r.top);

    _brokenVertical(path: path, x: r.right, fromY: r.top, toY: r.bottom, sideSeed: 1);
    _brokenHorizontal(path: path, y: r.bottom, fromX: r.right, toX: r.left, sideSeed: 2);
    _brokenVertical(path: path, x: r.left, fromY: r.bottom, toY: r.top, sideSeed: 3);

    path.close();
    return path;
  }

  Path _getBodyPath(Rect bodyRect) {
    if (_cachedBodyPath != null && _cachedSize != null && _cachedSize == bodyRect.size) {
      return _cachedBodyPath!;
    }

    final path = _tornRectPath(bodyRect);

    _cachedBodyPath = path;
    _cachedSize = bodyRect.size;

    return path;
  }

  void _brokenVertical({
    required Path path,
    required double x,
    required double fromY,
    required double toY,
    required int sideSeed,
  }) {
    final height = (toY - fromY).abs();
    const segments = 14;
    final step = height / segments;
    final amp = step * 0.6 * roughness;

    for (int i = 1; i < segments; i++) {
      final y = fromY + step * i * (toY > fromY ? 1 : -1);

      final n = _noise(sideSeed * 100 + i);
      final jitter = (n - 0.5) * amp;

      path.lineTo(x + jitter, y);
    }

    path.lineTo(x, toY);
  }

  void _brokenHorizontal({
    required Path path,
    required double y,
    required double fromX,
    required double toX,
    required int sideSeed,
  }) {
    final width = (toX - fromX).abs();
    const segments = 18;
    final step = width / segments;
    final amp = step * 0.6 * roughness;

    for (int i = 1; i < segments; i++) {
      final x = fromX + step * i * (toX > fromX ? 1 : -1);

      final n = _noise(sideSeed * 100 + i);
      final jitter = (n - 0.5) * amp;

      path.lineTo(x, y + jitter);
    }

    path.lineTo(toX, y);
  }

  // =====================================================
  // EARS
  // =====================================================

  Path _leftKnob(Size size) => Path()
    ..moveTo(sx(size, 20), sy(size, 24.4004))
    ..lineTo(sx(size, 19.2356), sy(size, 25.1479))
    ..cubicTo(
      sx(size, 17.3869),
      sy(size, 26.9558),
      sx(size, 14.4326),
      sy(size, 26.9558),
      sx(size, 12.5839),
      sy(size, 25.1479),
    )
    ..cubicTo(
      sx(size, 12.1369),
      sy(size, 24.7108),
      sx(size, 11.4467),
      sy(size, 24.6416),
      sx(size, 10.9217),
      sy(size, 24.9812),
    )
    ..lineTo(sx(size, 10.2288), sy(size, 25.4295))
    ..cubicTo(
      sx(size, 5.89744),
      sy(size, 28.2318),
      sx(size, 5.89744),
      sy(size, 34.569),
      sx(size, 10.2288),
      sy(size, 37.3713),
    )
    ..lineTo(sx(size, 10.9217), sy(size, 37.8196))
    ..cubicTo(
      sx(size, 11.4467),
      sy(size, 38.1592),
      sx(size, 12.1369),
      sy(size, 38.09),
      sx(size, 12.5839),
      sy(size, 37.6528),
    )
    ..cubicTo(
      sx(size, 14.4326),
      sy(size, 35.8449),
      sx(size, 17.3869),
      sy(size, 35.8449),
      sx(size, 19.2356),
      sy(size, 37.6528),
    )
    ..lineTo(sx(size, 20), sy(size, 38.4004))
    ..close();

  Path _rightKnob(Size size) => Path()
    ..moveTo(sx(size, 356), sy(size, 24.4004))
    ..lineTo(sx(size, 356.764), sy(size, 25.1479))
    ..cubicTo(
      sx(size, 358.613),
      sy(size, 26.9558),
      sx(size, 361.567),
      sy(size, 26.9558),
      sx(size, 363.416),
      sy(size, 25.1479),
    )
    ..cubicTo(
      sx(size, 363.863),
      sy(size, 24.7108),
      sx(size, 364.553),
      sy(size, 24.6416),
      sx(size, 365.078),
      sy(size, 24.9812),
    )
    ..lineTo(sx(size, 365.771), sy(size, 25.4295))
    ..cubicTo(
      sx(size, 370.103),
      sy(size, 28.2318),
      sx(size, 370.103),
      sy(size, 34.569),
      sx(size, 365.771),
      sy(size, 37.3713),
    )
    ..lineTo(sx(size, 365.078), sy(size, 37.8196))
    ..cubicTo(
      sx(size, 364.553),
      sy(size, 38.1592),
      sx(size, 363.863),
      sy(size, 38.09),
      sx(size, 363.416),
      sy(size, 37.6528),
    )
    ..cubicTo(
      sx(size, 361.567),
      sy(size, 35.8449),
      sx(size, 358.613),
      sy(size, 35.8449),
      sx(size, 356.764),
      sy(size, 37.6528),
    )
    ..lineTo(sx(size, 356), sy(size, 38.4004))
    ..close();

  @override
  bool shouldRepaint(covariant ScrollPainter oldDelegate) => oldDelegate.roughness != roughness;
}
