import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

/// The default smoothness value used for the decorated smooth radius.
const _defaultSmoothness = 0.6;

/// A widget that applies a smooth radius and optional decoration to its child.
class DecoratedSmoothRadius extends StatelessWidget {
  const DecoratedSmoothRadius({
    required this.child,
    this.side = BorderSide.none,
    this.borderRadius = 0,
    this.smoothness = _defaultSmoothness,
    this.shadow,
    this.color,
    super.key,
  });

  /// The [child] is the widget to be decorated.
  final Widget child;

  /// The [radius] defines the radius of the smooth corners.
  final double borderRadius;

  /// The [side] specifies the border of the widget.
  final BorderSide side;

  /// The [shadow] is a list of [BoxShadow] to apply to the widget.
  final List<BoxShadow>? shadow;

  /// The [color] is the background color of the widget.
  final Color? color;

  /// The [smoothness] determines the smoothness of the radius.
  /// by default it is set to 0.6.
  final double smoothness;

  @override
  Widget build(BuildContext context) {
    var child = this.child;
    if (color != null) {
      child = ColoredBox(
        color: color!,
        child: child,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: shadow,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SmoothClipRRect(
        smoothness: smoothness,
        borderRadius: BorderRadius.circular(borderRadius),
        side: side,
        child: child,
      ),
    );
  }
}
