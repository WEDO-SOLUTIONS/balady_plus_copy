// ignore_for_file: always_put_control_body_on_new_line, avoid_setters_without_getters

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ABDottedPathContainer extends SingleChildRenderObjectWidget {
  const ABDottedPathContainer({
    required this.color,
    required this.itemCount,
    required this.itemExtent,
    required this.relativeOffsets,
    this.xOffset = 28,
    this.dotRadius = 1,
    this.topOffset = 0,
    this.textDirection,
    Widget? child,
    super.key,
  }) : super(child: child);

  /// Color of the dots.
  final Color color;

  /// Number of list items (segments).
  final int itemCount;

  /// Height of one list item.
  final double itemExtent;

  /// Positions of dots inside a single item, as fractions of itemExtent (0..1).
  /// Example: [0.05, 0.35, 0.65, 0.95].
  final List<double> relativeOffsets;

  /// Horizontal offset from the left edge.
  final double xOffset;

  /// Dot radius.
  final double dotRadius;

  /// Vertical offset from the top of this container to the top of the first item.
  final double topOffset;

  /// The text direction to use for rendering the text.
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderABDottedPathContainer(
        color: color,
        itemCount: itemCount,
        itemExtent: itemExtent,
        relativeOffsets: relativeOffsets,
        xOffset: xOffset,
        dotRadius: dotRadius,
        textDirection: textDirection ?? Directionality.of(context),
        topOffset: topOffset,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderABDottedPathContainer renderObject,
  ) {
    renderObject
      ..color = color
      ..itemCount = itemCount
      ..itemExtent = itemExtent
      ..relativeOffsets = relativeOffsets
      ..xOffset = xOffset
      ..dotRadius = dotRadius
      ..topOffset = topOffset;
  }
}

class _RenderABDottedPathContainer extends RenderProxyBox {
  _RenderABDottedPathContainer({
    required Color color,
    required int itemCount,
    required double itemExtent,
    required List<double> relativeOffsets,
    required double xOffset,
    required double dotRadius,
    required double topOffset,
    required TextDirection textDirection,
  })  : _color = color,
        _itemCount = itemCount,
        _itemExtent = itemExtent,
        _relativeOffsets = List<double>.from(relativeOffsets),
        _xOffset = xOffset,
        _dotRadius = dotRadius,
        _textDirection = textDirection,
        _topOffset = topOffset;

  Color _color;
  int _itemCount;
  double _itemExtent;
  List<double> _relativeOffsets;
  double _xOffset;
  double _dotRadius;
  double _topOffset;
  TextDirection _textDirection;

  set color(Color value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  set itemCount(int value) {
    if (value == _itemCount) return;
    _itemCount = value;
    markNeedsPaint();
  }

  set itemExtent(double value) {
    if (value == _itemExtent) return;
    _itemExtent = value;
    markNeedsPaint();
  }

  set relativeOffsets(List<double> value) {
    if (_relativeOffsets.length == value.length && _relativeOffsets.every((v) => value.contains(v))) {
      return;
    }
    _relativeOffsets = List<double>.from(value);
    markNeedsPaint();
  }

  set xOffset(double value) {
    if (value == _xOffset) return;
    _xOffset = value;
    markNeedsPaint();
  }

  set dotRadius(double value) {
    if (value == _dotRadius) return;
    _dotRadius = value;
    markNeedsPaint();
  }

  set topOffset(double value) {
    if (value == _topOffset) return;
    _topOffset = value;
    markNeedsPaint();
  }

  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsPaint();
  }

  Iterable<double> _filteredFractionsForIndex(int index) {
    // Base pattern: 3 dots
    final List<double> base = _relativeOffsets;

    if (_itemCount == 1) {
      // Only one item → leave all three
      return base;
    }

    if (index == 0) {
      // First item → remove fractions < 0.5 (points above the badge)
      return base.where((f) => f >= 0.5);
    }

    if (index == _itemCount - 1) {
      // Last item → remove fractions > 0.5 (points below the badge)
      return base.where((f) => f <= 0.5);
    }

    // Middle items → 3 dots
    return base;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    if (_itemCount <= 0 || _itemExtent <= 0 || _relativeOffsets.isEmpty) {
      super.paint(context, offset);
      return;
    }

    final double minY = offset.dy;
    final double maxY = offset.dy + size.height;
    final double columnX =
        _textDirection == TextDirection.rtl ? offset.dx + size.width - _xOffset : offset.dx + _xOffset;

    for (int index = 0; index < _itemCount; index++) {
      final double itemTop = offset.dy + _topOffset + index * _itemExtent;
      final double itemBottom = itemTop + _itemExtent;

      if (itemBottom < minY || itemTop > maxY) continue;

      // Choose which fractions to use for this item.
      final fractions = _filteredFractionsForIndex(index);

      for (final fraction in fractions) {
        final double f = fraction.clamp(0.0, 1.0);
        final double y = itemTop + f * _itemExtent;

        if (y < minY + _dotRadius || y > maxY - _dotRadius) continue;

        canvas.drawCircle(Offset(columnX, y), _dotRadius, paint);
      }
    }

    super.paint(context, offset);
  }
}
