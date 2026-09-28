import 'package:flutter/widgets.dart';

/// Reveals [fill] over [background] from the start edge (right in RTL) during [duration],
/// then calls [onCompleted] once. Disposing the widget earlier cancels the callback.
class TimedFillButton extends StatefulWidget {
  const TimedFillButton({
    required this.duration,
    required this.background,
    required this.fill,
    this.onCompleted,
    super.key,
  });

  final Duration duration;
  final Widget background;
  final Widget fill;
  final VoidCallback? onCompleted;

  @override
  State<TimedFillButton> createState() => _TimedFillButtonState();
}

class _TimedFillButtonState extends State<TimedFillButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(duration: widget.duration, vsync: this);

  @override
  void initState() {
    super.initState();
    _controller.forward().then((_) {
      if (mounted) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromRight = Directionality.maybeOf(context) == TextDirection.rtl;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.background,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ClipRect(
            clipper: _FillClipper(_controller.value, fromRight: fromRight),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
          child: widget.fill,
        ),
      ],
    );
  }
}

class _FillClipper extends CustomClipper<Rect> {
  const _FillClipper(this.progress, {required this.fromRight});

  final double progress;
  final bool fromRight;

  @override
  Rect getClip(Size size) {
    final width = size.width * progress;
    return Rect.fromLTWH(fromRight ? size.width - width : 0, 0, width, size.height);
  }

  @override
  bool shouldReclip(covariant _FillClipper oldClipper) =>
      oldClipper.progress != progress || oldClipper.fromRight != fromRight;
}
