import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that provides a custom shadow effect to its single child.
///
/// The [ShapeShadow] widget wraps a single child and applies a shadow
/// effect to it, allowing for custom shadow shapes and properties.
///
/// Typically used to enhance the visual appearance of UI elements by
/// adding depth and elevation through shadow rendering.
///
/// See also:
///
///  * [SingleChildRenderObjectWidget], which this widget extends.
///  * [BoxShadow], for standard shadow effects on containers.
class ShapeShadow extends SingleChildRenderObjectWidget {
  final ShapeBorder shape;
  final List<BoxShadow> boxShadow;

  const ShapeShadow({
    required this.shape,
    required this.boxShadow,
    super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => RenderShapeShadow(shadows: boxShadow, shape: shape);

  @override
  void updateRenderObject(BuildContext context, covariant RenderShapeShadow renderObject) {
    renderObject
      .._boxShadow = boxShadow
      .._shape = shape;
  }
}

class RenderShapeShadow extends RenderProxyBox {
  ShapeBorder _shape;

  ShapeBorder get shape => _shape;

  set shape(ShapeBorder value) {
    if (_shape != value) {
      _shape = value;
      markNeedsPaint();
    }
  }

  List<BoxShadow> _boxShadow;

  List<BoxShadow> get boxShadow => _boxShadow;

  set boxShadow(List<BoxShadow> value) {
    if (_boxShadow != value) {
      _boxShadow = value;
      markNeedsPaint();
    }
  }

  RenderShapeShadow({
    required ShapeBorder shape,
    required List<BoxShadow> shadows,
  })  : _boxShadow = shadows,
        _shape = shape;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final Path path = shape.getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw each shadow
    for (final shadow in boxShadow) {
      final Paint shadowPaint = Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _convertRadiusToSigma(shadow.blurRadius));
      canvas
        ..save()
        ..translate(shadow.offset.dx + offset.dx, shadow.offset.dy + offset.dy)
        ..drawPath(path, shadowPaint)
        ..restore();
    }

    super.paint(context, offset);
  }

  double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
