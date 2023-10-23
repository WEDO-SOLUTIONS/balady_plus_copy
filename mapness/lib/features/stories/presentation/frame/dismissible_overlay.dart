import 'package:flutter/material.dart';

class DismissibleOverlay {
  OverlayEntry? _overlayEntry;

  DismissibleOverlay();

  void open({required BuildContext context, required Widget widget}) {
    if (_overlayEntry != null) {
      close();
    }

    _overlayEntry = _wrap(widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _wrap(Widget widget) {
    return OverlayEntry(
      builder: (context) => widget,
    );
  }
}

class MyWidgetChild extends StatelessWidget {
  const MyWidgetChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DismissibleTransition extends StatefulWidget {
  final Widget child;
  const DismissibleTransition({
    super.key,
    required this.onDismiss,
    required this.child,
  });

  final void Function() onDismiss;

  @override
  State<DismissibleTransition> createState() => DismissibleTransitionState();
}

class DismissibleTransitionState extends State<DismissibleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    )..addStatusListener(
        (AnimationStatus status) {
          if (status == AnimationStatus.dismissed) {
            widget.onDismiss();
          }
        },
      );
    _controller.forward();
  }

  void dismiss() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _controller.value -=
            details.delta.dy / MediaQuery.of(context).size.height;
      },
      onVerticalDragEnd: (details) {
        final predictedValue = _controller.value -
            details.velocity.pixelsPerSecond.dy *
                0.25 /
                MediaQuery.of(context).size.height;
        if (predictedValue < 0.6) {
          _controller.reverse(from: _controller.value);
        } else {
          _controller.forward(from: _controller.value);
        }
      },
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: _opacityAnimation.value,
                child: Container(color: const Color(0xff141414)),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    0.0,
                    MediaQuery.of(context).size.height *
                        (1 - _opacityAnimation.value),
                    0.0,
                  )
                  ..scale(
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                  ),
                origin: Offset(MediaQuery.of(context).size.width * 0.5, 0),
                child: child!,
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
