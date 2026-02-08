import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/slider/slider_controller.dart';
import 'package:balady_uikit/src/components/slider/slider_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// A widget that displays a horizontal list of items with custom slider behavior.
///
/// The [SliderListView] is designed for paginated horizontal scrolling of items,
/// with features like custom padding, separation between items, and an optional
/// smooth page indicator.
class SliderListView<T> extends StatefulWidget {
  /// The list of items to be displayed in the slider.
  final List<T> items;

  /// The width or height of each item's content.
  final double contentSize;

  /// The total width of the viewport for the slider.
  final double viewportWidth;

  /// Whether to show the page indicator at the bottom of the slider.
  final bool showIndicator;

  /// Horizontal padding around the slider content.
  final double horizontalPadding;

  /// The spacing between items in the slider.
  final double separationWidth;

  /// A callback triggered when an item is tapped.
  final void Function(T item)? onTap;

  /// A builder function to construct each item's widget.
  final Widget Function(T? item) itemBuilder;

  final Color? activeDotColor;
  final Color? dotColor;

  /// Creates a [SliderListView] with the specified parameters.
  ///
  /// - [items]: The list of items to display.
  /// - [itemBuilder]: A builder function to create the widget for each item.
  /// - [contentSize]: The size of each item's content.
  /// - [viewportWidth]: The width of the slider's viewport.
  ///
  /// Optional parameters include [onTap], [horizontalPadding], [separationWidth],
  /// and [showIndicator].
  const SliderListView({
    required this.items,
    required this.itemBuilder,
    required this.contentSize,
    required this.viewportWidth,
    this.onTap,
    this.horizontalPadding = Spacing.$4x,
    this.separationWidth = Spacing.$3x,
    this.showIndicator = true,
    this.activeDotColor,
    this.dotColor,
    super.key,
  });

  @override
  State<SliderListView<T>> createState() => _SliderListViewState<T>();
}

/// The state class for [SliderListView], managing the slider's behavior and interaction.
class _SliderListViewState<T> extends State<SliderListView<T>> {
  /// The controller used to manage the slider's scrolling behavior.
  late SliderController controller;

  @override
  void initState() {
    super.initState();
    controller = SliderController(
      horizontalPadding: widget.horizontalPadding,
      separationWidth: widget.separationWidth,
      viewportFraction:
          widget.items.length > 1 ? (widget.contentSize + widget.separationWidth) / widget.viewportWidth : 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant SliderListView<T> oldWidget) {
    // Update the controller when widget properties that affect the slider change.
    if (oldWidget.items.length != widget.items.length ||
        oldWidget.horizontalPadding != widget.horizontalPadding ||
        oldWidget.separationWidth != widget.separationWidth ||
        oldWidget.viewportWidth != widget.viewportWidth) {
      controller = SliderController(
        horizontalPadding: widget.horizontalPadding,
        separationWidth: widget.separationWidth,
        viewportFraction:
            widget.items.length > 1 ? (widget.contentSize + widget.separationWidth) / widget.viewportWidth : 1.0,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = widget.items.length == 1
        ? widget.viewportWidth - widget.horizontalPadding * 2 - widget.separationWidth
        : widget.contentSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.contentSize,
          child: widget.items.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                  child: widget.itemBuilder(null),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  physics: SliderScrollPhysics(
                    padding: widget.horizontalPadding + widget.separationWidth / 2,
                    itemSize: contentWidth + widget.separationWidth,
                    separationWidth: widget.separationWidth,
                  ),
                  controller: controller,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.separationWidth / 2),
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
        if (widget.showIndicator && widget.items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.$3x),
            child: SmoothDotSliderIndicator(
              onDotClicked: (index) {
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
                dotColor: widget.dotColor ?? context.colors.foregroundDisabled,
                activeDotColor: widget.activeDotColor ?? context.colors.foregroundDefault,
              ),
            ),
          ),
      ],
    );
  }
}

/// A custom page indicator widget for a slider.
///
/// The [SmoothDotSliderIndicator] synchronizes with the [SliderController] and
/// provides visual feedback on the current page being displayed.
class SmoothDotSliderIndicator extends StatefulWidget {
  /// The controller that manages the slider.
  final SliderController controller;

  /// Holds the effect configuration for the indicator.
  final IndicatorEffect effect;

  /// The layout direction (vertical or horizontal).
  ///
  /// This rotates the canvas for the indicator dots, but does not affect their dimensions.
  final Axis axisDirection;

  /// The total number of pages in the slider.
  final int count;

  /// The text direction, used to adjust dot alignment for RTL languages.
  final TextDirection? textDirection;

  /// A callback triggered when a dot is clicked.
  final OnDotClicked? onDotClicked;

  /// Creates a custom smooth dot slider indicator.
  const SmoothDotSliderIndicator({
    required this.controller,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    Key? key,
  }) : super(key: key);

  @override
  State<SmoothDotSliderIndicator> createState() => _SmoothDotSliderIndicatorState();
}

/// State class for [SmoothDotSliderIndicator], managing the rendering and behavior of the dots.
class _SmoothDotSliderIndicatorState extends State<SmoothDotSliderIndicator> {
  /// The size of the canvas for drawing the dots.
  late Size size;

  /// The rotation applied to the canvas for the indicator dots.
  int quarterTurns = 0;

  /// Calculates the current offset for the active dot in the indicator.
  double get _offset {
    try {
      final offset = widget.controller.slide ?? widget.controller.initialSlide.toDouble();
      return offset % widget.count;
    } on Exception catch (_) {
      return widget.controller.initialSlide.toDouble();
    }
  }

  @override
  void initState() {
    super.initState();
    updateSizeAndRotation();
  }

  @override
  void didUpdateWidget(covariant SmoothDotSliderIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSizeAndRotation();
  }

  /// Updates the size and rotation properties for the indicator based on its settings.
  void updateSizeAndRotation() {
    size = widget.effect.calculateSize(widget.count);

    /// If textDirection is not provided, use the nearest directionality up the widget tree.
    final isRTL = (widget.textDirection ?? _getDirectionality()) == TextDirection.rtl;
    if (widget.axisDirection == Axis.vertical) {
      quarterTurns = 1;
    } else {
      quarterTurns = isRTL ? 2 : 0;
    }
  }

  /// Retrieves the text direction from the nearest ancestor widget.
  TextDirection? _getDirectionality() => context.findAncestorWidgetOfExactType<Directionality>()?.textDirection;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => SmoothIndicator(
          offset: _offset,
          count: widget.count,
          effect: widget.effect,
          onDotClicked: widget.onDotClicked,
          size: size,
          quarterTurns: quarterTurns,
        ),
      );
}
