import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A widget that animates the decoration of a box over a given duration whenever
/// the decoration changes.
///
/// This widget is a subclass of [ImplicitlyAnimatedWidget], which means it will
/// automatically animate changes to its properties.
///
/// The [AnimatedDecoratedBox] requires a [decoration] and a [duration] to be
/// specified. The [decoration] is the new decoration to animate to, and the
/// [duration] is the length of time the animation should take.
///
/// Example usage:
/// ```dart
/// AnimatedDecoratedBox(
///   decoration: BoxDecoration(
///     color: Colors.blue,
///     borderRadius: BorderRadius.circular(8.0),
///   ),
///   duration: Duration(seconds: 1),
///   child: Container(
///     width: 100,
///     height: 100,
///   ),
/// );
/// ```
///
/// See also:
///  * [Decoration], which is the base class for all decorations.
///  * [BoxDecoration], which is a concrete implementation of [Decoration].
///  * [ImplicitlyAnimatedWidget], which this widget extends.
class AnimatedDecoratedBox extends ImplicitlyAnimatedWidget {
  /// Creates a container that animates its parameters implicitly.
  const AnimatedDecoratedBox({
    required this.decoration,
    required super.duration,
    this.child,
    super.curve,
    super.onEnd,
    super.key,
  });

  /// The [child] contained by the container.
  ///
  /// If null, and if the [constraints] are unbounded or also null, the
  /// container will expand to fill all available space in its parent, unless
  /// the parent provides unbounded constraints, in which case the container
  /// will attempt to be as small as possible.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The decoration to paint behind the [child].
  final Decoration decoration;

  @override
  AnimatedWidgetBaseState<AnimatedDecoratedBox> createState() => _AnimatedContainerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>('bg', decoration, defaultValue: null));
  }
}

class _AnimatedContainerState extends AnimatedWidgetBaseState<AnimatedDecoratedBox> {
  late DecorationTween _decoration;

  @override
  void initState() {
    _decoration = DecorationTween(begin: widget.decoration, end: widget.decoration);
    super.initState();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _decoration = visitor(_decoration, widget.decoration, (value) => DecorationTween(begin: value as Decoration))!
        as DecorationTween;
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: _decoration.evaluate(animation),
        child: widget.child,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<DecorationTween>('bg', _decoration, defaultValue: null));
  }
}
