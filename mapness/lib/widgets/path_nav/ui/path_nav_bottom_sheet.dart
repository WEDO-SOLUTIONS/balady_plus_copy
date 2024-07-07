import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/path_nav/lib/no_overscroll_behavior.dart';

class PathNavBottomSheet extends StatefulWidget {
  const PathNavBottomSheet({
    required this.header,
    required this.body,
    required this.maxSize,
    required this.minSize,
    required this.controller,
    super.key,
  });

  final Widget header;
  final Widget body;
  final double maxSize;
  final double minSize;
  final DraggableScrollableController controller;

  @override
  State<PathNavBottomSheet> createState() => _PathNavBottomSheetState();
}

class _PathNavBottomSheetState extends State<PathNavBottomSheet> with SingleTickerProviderStateMixin {
  DraggableScrollableController get _dragController => widget.controller;

  double get _minSize => widget.minSize;

  double get _maxSize => widget.maxSize;

  /// animation between 0 and 1 when is opened toggled
  final Tween<double> _animationTween = Tween(begin: 1, end: 0);
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  void _onScroll() {
    final size = _dragController.size;
    final isExpanded = size > _minSize;
    if (isExpanded) {
      _animationController.forward();
    }
    if (!isExpanded) {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _dragController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );

    _animation = _animationTween.animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _dragController
      ..removeListener(_onScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.easeInOut;
    const duration = Duration(milliseconds: 70);

    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: _minSize,
      minChildSize: _minSize,
      maxChildSize: _maxSize,
      controller: _dragController,
      builder: (context, scrollController) => ValueListenableBuilder(
        valueListenable: _animation,
        builder: (context, state, child) {
          final showColor = state < 1;
          return Padding(
            padding: EdgeInsets.only(
              left: 12 * state,
              right: 12 * state,
            ),

            /// bg
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: showColor ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: Radius.circular(16 * state),
                ),
              ),
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                decoration: BoxDecoration(
                  color: showColor ? context.color.surfaceBasePrimary : Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(16),
                    bottom: Radius.circular(16 * state),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: NoOverscrollBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// header
                      AnimatedContainer(
                        curve: curve,
                        duration: duration,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(16),
                            bottom: Radius.circular(16 * state),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: 12,
                          right: 12,
                          bottom: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// handle
                            const SheetDragger(),
                            const SizedBox(height: 4),
                            SafeArea(
                              bottom: !_dragController.isAttached || _dragController.size <= 0.03,
                              top: false,
                              child: widget.header,
                            ),
                          ],
                        ),
                      ),

                      /// body
                      AnimatedOpacity(
                        opacity: 1 - state,
                        curve: curve,
                        duration: duration,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SafeArea(
                            top: false,
                            child: widget.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
