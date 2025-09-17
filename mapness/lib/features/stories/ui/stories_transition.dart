import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';

class StoriesTransition extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClose;
  final StoryTypes type;

  const StoriesTransition({
    required this.child,
    required this.type,
    this.onClose,
    super.key,
  });

  @override
  State<StoriesTransition> createState() => _StoriesTransitionState();
}

const double _dismissOffsetRatio = 0.9;
const Duration _hideDuration = Duration(milliseconds: 500);

class _StoriesTransitionState extends State<StoriesTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _hideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _hideDuration,
    );
    _hideAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss({double? from}) async {
    await _controller.reverse(from: from);
    widget.onClose?.call();
    if (mounted && context.router.canPop()) {
      context.router.popForced();
    }
  }

  double _calculateRatio(double value) => value / MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) => PopScope(
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            await _dismiss();
          }
        },
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            /// Disable swipe to dismiss for onboarding stories
            if (widget.type == StoryTypes.onboarding) {
              return;
            }
            _controller.value -= _calculateRatio(details.delta.dy);
          },
          onVerticalDragEnd: (details) {
            /// Disable swipe to dismiss for onboarding stories
            if (widget.type == StoryTypes.onboarding) {
              return;
            }
            final predictedValue = _controller.value - _calculateRatio(details.velocity.pixelsPerSecond.dy * 0.25);
            if (predictedValue < _dismissOffsetRatio) {
              _dismiss(from: _controller.value);
              return;
            }
            _controller.forward(from: _controller.value);
          },
          child: widget.type != StoryTypes.onboarding
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) => Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                          color: Colors.black.withOpacity(
                        _hideAnimation.value,
                      )),
                      SlideTransition(
                        position: AlwaysStoppedAnimation(
                          Offset(0, 1 - _hideAnimation.value),
                        ),
                        child: Transform.scale(
                          scale: _hideAnimation.value,
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Colors.black),
                    widget.child,
                  ],
                ),
        ),
      );
}
