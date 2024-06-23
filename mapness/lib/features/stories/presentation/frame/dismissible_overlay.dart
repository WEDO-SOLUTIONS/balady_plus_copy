import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DismissibleTransition extends StatefulWidget {
  const DismissibleTransition({
    required this.onDismiss,
    required this.child,
    super.key,
  });
  final Widget child;

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

  void dismiss() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onVerticalDragUpdate: (details) {
          _controller.value -= details.delta.dy / MediaQuery.of(context).size.height;
        },
        onVerticalDragEnd: (details) {
          final predictedValue =
              _controller.value - details.velocity.pixelsPerSecond.dy * 0.25 / MediaQuery.of(context).size.height;
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
                    MediaQuery.of(context).size.height * (1 - _opacityAnimation.value),
                  )
                  ..scale(
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                  ),
                origin: Offset(MediaQuery.of(context).size.width * 0.5, 0),
                child: child,
              ),
            ],
          ),
          child: widget.child,
        ),
      );
}
