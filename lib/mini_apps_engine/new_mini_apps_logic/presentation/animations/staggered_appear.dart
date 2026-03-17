import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Use this for small groups of widgets (e.g., 3–10 form fields).
/// It plays a one-shot staggered fade+slide on first build.
class StaggeredAppear extends StatefulWidget {
  const StaggeredAppear({
    super.key,
    required this.children,
    this.initialDelay = const Duration(milliseconds: 120),
    this.itemDuration = const Duration(milliseconds: 320),
    this.itemDelay = const Duration(milliseconds: 90),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, .12), // slide up a bit
    this.opacityBegin = 0.0,
    this.opacityEnd = 1.0,
    this.animateOnce = true, // if true, won’t replay on rebuilds
    this.onCompleted,
  });

  /// Widgets to animate in order.
  final List<Widget> children;

  /// Delay before the first child starts.
  final Duration initialDelay;

  /// Animation duration for each item.
  final Duration itemDuration;

  /// Stagger gap between each item’s start time.
  final Duration itemDelay;

  /// Curve for both opacity & slide.
  final Curve curve;

  /// Where the slide starts from (Offset.dx, Offset.dy) in fractional cells.
  /// Example: Offset(0, .12) = 12% of child height from below.
  final Offset beginOffset;

  /// Opacity range.
  final double opacityBegin;
  final double opacityEnd;

  /// If true, plays only once per mount.
  final bool animateOnce;

  final VoidCallback? onCompleted;

  @override
  State<StaggeredAppear> createState() => _StaggeredAppearState();
}

class _StaggeredAppearState extends State<StaggeredAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _done = false;

  @override
  void initState() {
    super.initState();

    final total = widget.initialDelay +
        (widget.children.isEmpty
            ? Duration.zero
            : widget.itemDuration +
                widget.itemDelay * (widget.children.length - 1));

    _controller = AnimationController(vsync: this, duration: total)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _done = true;
          widget.onCompleted?.call();
        }
      });

    // Start after initial delay
    Future<void>.delayed(widget.initialDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant StaggeredAppear oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If developer explicitly wants replay, wrap with a UniqueKey() when rebuilding.
    // Otherwise respect animateOnce = true and keep it completed.
    if (!widget.animateOnce && _done) {
      _done = false;
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Interval _intervalForIndex(int i) {
    // Compute each item’s time window within controller’s [0..1]
    final totalMs = (_controller.duration?.inMilliseconds ?? 1).toDouble();
    final startMs = widget.initialDelay.inMilliseconds +
        (widget.itemDelay.inMilliseconds * i);
    final endMs = startMs + widget.itemDuration.inMilliseconds;
    final start = (startMs / totalMs).clamp(0.0, 1.0);
    final end = (endMs / totalMs).clamp(start + 0.001, 1.0);
    return Interval(start, end, curve: widget.curve);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.children.length, (i) {
            final interval = _intervalForIndex(i);

            final t = interval.transform(
              // protect against values < 0 during initial delay
              _controller.value.clamp(0.0, 1.0),
            );

            final opacity = lerpDouble(
              widget.opacityBegin,
              widget.opacityEnd,
              t,
            );
            final dy = lerpDouble(widget.beginOffset.dy, 0, t);
            final dx = lerpDouble(widget.beginOffset.dx, 0, t);

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(dx, dy) * _translationBaseFor(context),
                child: widget.children[i],
              ),
            );
          }),
        );
      },
    );
  }

  // Convert fractional Offset to pixels relative to a reasonable base (screen size).
  double _translationBaseFor(BuildContext context) {
    // Use min dimension to keep consistent feel in portrait/landscape.
    final size = MediaQuery.sizeOf(context);
    return math.min(size.width, size.height);
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

/// Builder version for big/virtualized lists.
/// Animate the first [animateCount] items (or all if null) using the same stagger.
class StaggeredAppearBuilder extends StatelessWidget {
  const StaggeredAppearBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.animateCount,
    this.initialDelay = Duration.zero,
    this.itemDuration = const Duration(milliseconds: 300),
    this.itemDelay = const Duration(milliseconds: 80),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, .12),
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int? animateCount;

  final Duration initialDelay;
  final Duration itemDuration;
  final Duration itemDelay;
  final Curve curve;
  final Offset beginOffset;

  @override
  Widget build(BuildContext context) {
    final countToAnimate = animateCount ?? itemCount;
    final children = List<Widget>.generate(
      itemCount,
      (i) => itemBuilder(context, i),
    );

    return StaggeredAppear(
      initialDelay: initialDelay,
      itemDuration: itemDuration,
      itemDelay: itemDelay,
      curve: curve,
      beginOffset: beginOffset,
      animateOnce: true,
      children: List.generate(itemCount, (i) {
        final child = children[i];
        if (i >= countToAnimate) return child; // no animation for the rest
        return child;
      }),
    );
  }
}
