import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderListView<T> extends StatefulWidget {
  final List<T> items;
  final double contentSize;
  final bool vibrateOnChange;
  final double viewportWidth;

  final void Function(T item)? onTap;
  final Widget Function(T? item) itemBuilder;

  const SliderListView({
    required this.items,
    required this.itemBuilder,
    required this.contentSize,
    required this.viewportWidth,
    this.vibrateOnChange = true,
    this.onTap,
    super.key,
  });

  @override
  State<SliderListView<T>> createState() => _SliderListViewState<T>();
}

class _SliderListViewState<T> extends State<SliderListView<T>> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      viewportFraction: widget.items.length > 1 ? widget.contentSize / widget.viewportWidth : 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant SliderListView<T> oldWidget) {
    if (oldWidget.items.length != widget.items.length) {
      controller = PageController(
        viewportFraction: widget.items.length > 1 ? widget.contentSize / widget.viewportWidth : 1.0,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = widget.items.length == 1 ? MediaQuery.sizeOf(context).width - Spacing.$8x : widget.contentSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.contentSize,
          child: widget.items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  child: widget.itemBuilder(null),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
                  scrollDirection: Axis.horizontal,
                  reverse: context.isRTL,
                  physics: SliderScrollPhysics(
                    padding: Spacing.$4x,
                    itemSize: contentWidth + Spacing.$2x,
                  ),
                  controller: controller,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$1x),
                      child: SizedBox(
                        width: contentWidth,
                        child: GestureDetector(
                          onTap: () => widget.onTap?.call(item),
                          child: widget.itemBuilder(item),
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (widget.items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.$3x),
            child: SmoothPageIndicator(
              textDirection: TextDirection.ltr,
              onDotClicked: (index) {
                // final offset = index * (widget.contentSize) - Spacing.$2x;

                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                );
              },
              controller: controller,
              count: widget.items.length,
              effect: ScrollingDotsEffect(
                radius: 100.0,
                dotWidth: 6.0,
                dotHeight: 6.0,
                dotColor: context.colorsV2.foregroundDisabled,
                activeDotColor: context.colorsV2.foregroundDefault,
              ),
            ),
          ),
      ],
    );
  }
}

class SliderScrollPhysics extends ScrollPhysics {
  final double padding;
  final double itemSize;

  const SliderScrollPhysics({
    required this.padding,
    required this.itemSize,
  }) : super(parent: const BouncingScrollPhysics());

  @override
  bool get allowImplicitScrolling => false;

  @override
  SliderScrollPhysics applyTo(ScrollPhysics? ancestor) => SliderScrollPhysics(itemSize: itemSize, padding: padding);

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    /// If the scroll position is out of bounds and the velocity indicates
    /// we are not moving back towards the valid range, delegate to the parent
    /// ballistics to handle the motion. This ensures the position snaps
    /// back to a valid boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    final contentPadding = (position.extentInside - itemSize) / 2;
    final endPosition = getEndPosition(position, tolerance, velocity, contentPadding) + padding;

    if (endPosition != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        endPosition,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  double getEndPosition(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
    double contentPadding,
  ) {
    double offset() {
      if (velocity < -tolerance.velocity) {
        return -0.5;
      } else if (velocity > tolerance.velocity) {
        return 0.5;
      }
      return 0.0;
    }

    final itemIndex = ((position.pixels + contentPadding) / itemSize + offset()).roundToDouble();

    return (itemIndex * itemSize) - contentPadding;
  }
}
