import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// A widget that provides a dismissible transition effect to its child widget.
class DismissibleTransition extends StatefulWidget {
  /// Creates a [DismissibleTransition] widget.
  ///
  /// The [onDismiss] callback is called when the widget is dismissed.
  /// The [child] widget is the content of the dismissible transition.
  const DismissibleTransition({
    required this.onDismiss,
    required this.child,
    super.key,
  });

  /// The content of the dismissible transition.
  final Widget child;

  /// The callback function called when the widget is dismissed.
  final void Function() onDismiss;

  @override
  State<DismissibleTransition> createState() => DismissibleTransitionState();
}

class DismissibleTransitionState extends State<DismissibleTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  static const _animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _opacityAnimation = (Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.dismissed) {
            widget.onDismiss();
          }
        },
      ));
    _controller.forward();
  }

  /// Dismisses the widget by reversing the animation.
  void dismiss() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _controller.value -= details.delta.dy / size.height;
      },
      onVerticalDragEnd: (details) {
        final predictedValue = _controller.value - details.velocity.pixelsPerSecond.dy * 0.25 / size.height;
        if (predictedValue < 0.6) {
          _controller.reverse(from: _controller.value);
        } else {
          _controller.forward(from: _controller.value);
        }
      },
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) => Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: _opacityAnimation.value,
              child: ColoredBox(color: context.color.textAndIconsBasePrimary),
            ),
            Transform(
              transform: Matrix4.identity()
                ..translate(
                  0.0,
                  size.height * (1 - _opacityAnimation.value),
                )
                ..scale(
                  0.8 + 0.2 * _opacityAnimation.value,
                  0.8 + 0.2 * _opacityAnimation.value,
                  0.8 + 0.2 * _opacityAnimation.value,
                ),
              origin: Offset(size.width * 0.5, 0),
              child: child,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
