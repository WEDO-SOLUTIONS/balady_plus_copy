import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A custom scroll controller for managing a slider with paginated views.
///
/// The [SliderController] extends [ScrollController] to provide additional
/// functionality for paginated scrolling, including snapping to pages and
/// managing viewport properties such as padding and separation between items.
class SliderController extends ScrollController {
  /// Horizontal padding around the slider content.
  final double horizontalPadding;

  /// The separation width between items in the slider.
  final double separationWidth;

  /// The initial slide (page) to display when the slider is first created.
  final int initialSlide;

  /// Determines whether the current slide is saved and restored when the
  /// controller's scrollable is recreated.
  ///
  /// If true (default), the current slide is stored using [PageStorage].
  final bool keepSlide;

  /// The fraction of the viewport that each page occupies.
  ///
  /// Defaults to `1.0`, meaning each page fills the viewport.
  final double viewportFraction;

  /// Creates a custom slider controller.
  ///
  /// [horizontalPadding], [separationWidth], and other parameters must be provided.
  /// Defaults are set for [initialSlide], [keepSlide], and [viewportFraction].
  SliderController({
    required this.horizontalPadding,
    required this.separationWidth,
    this.initialSlide = 0,
    this.keepSlide = true,
    this.viewportFraction = 1.0,
    super.onAttach,
    super.onDetach,
  });

  /// Retrieves the current slide (page) being displayed.
  ///
  /// Throws an assertion error if the controller is not attached to a [ListView]
  /// or if multiple [ListView]s are using the same controller.
  double? get slide {
    assert(
      positions.isNotEmpty,
      'SliderController.slide cannot be accessed before a ListView is built with it.',
    );
    assert(
      positions.length == 1,
      'The slide property cannot be read when multiple ListViews are attached to the same SliderController.',
    );
    final SliderPosition position = this.position as SliderPosition;
    return position.page;
  }

  /// Animates the controlled [ListView] to a specific page.
  ///
  /// - [page]: The target page index.
  /// - [duration]: The duration of the animation.
  /// - [curve]: The animation curve.
  ///
  /// Returns a [Future] that resolves when the animation completes.
  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    final SliderPosition position = this.position as SliderPosition;
    if (position._cachedPage != null) {
      position._cachedPage = page.toDouble();
      return Future<void>.value();
    }

    return position.animateTo(
      position.getPixelsFromPage(page.toDouble()),
      duration: duration,
      curve: curve,
    );
  }

  /// Jumps to a specific page in the [ListView] without animation.
  ///
  /// This changes the page position immediately and does not validate the range.
  void jumpToPage(int page) {
    final SliderPosition position = this.position as SliderPosition;
    if (position._cachedPage != null) {
      position._cachedPage = page.toDouble();
      return;
    }

    position.jumpTo(position.getPixelsFromPage(page.toDouble()));
  }

  /// Animates the [ListView] to the next page.
  ///
  /// - [duration]: The duration of the animation.
  /// - [curve]: The animation curve.
  ///
  /// Returns a [Future] that resolves when the animation completes.
  Future<void> nextPage({required Duration duration, required Curve curve}) =>
      animateToPage(slide!.round() + 1, duration: duration, curve: curve);

  /// Animates the [ListView] to the previous page.
  ///
  /// - [duration]: The duration of the animation.
  /// - [curve]: The animation curve.
  ///
  /// Returns a [Future] that resolves when the animation completes.
  Future<void> previousPage({required Duration duration, required Curve curve}) =>
      animateToPage(slide!.round() - 1, duration: duration, curve: curve);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) =>
      SliderPosition(
        physics: physics,
        context: context,
        separationWidth: separationWidth,
        horizontalPadding: horizontalPadding,
        initialPage: initialSlide,
        keepPage: keepSlide,
        viewportFraction: viewportFraction,
        oldPosition: oldPosition,
      );

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    (position as SliderPosition).viewportFraction = viewportFraction;
  }
}

/// Represents the scroll position for a [SliderController].
///
/// This class manages the snapping behavior, page calculations, and custom
/// viewport adjustments for the slider.
class SliderPosition extends ScrollPositionWithSingleContext implements PageMetrics {
  /// Horizontal padding for the slider content.
  final double horizontalPadding;

  /// The separation width between items in the slider.
  final double separationWidth;

  /// The initial page to display.
  final int initialPage;

  /// Fraction of the viewport that each page occupies.
  double _viewportFraction;

  /// Cached page value for cases where the viewport has zero size.
  double? _cachedPage;

  /// Cached page value used during initialization.
  double _pageToUseOnStartup;

  /// Creates a custom scroll position for the slider.
  ///
  /// The parameters [physics], [context], [horizontalPadding], and
  /// [separationWidth] are required. Additional properties, such as
  /// [viewportFraction] and [keepPage], define the snapping behavior.
  SliderPosition({
    required super.physics,
    required super.context,
    required this.horizontalPadding,
    required this.separationWidth,
    this.initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    super.oldPosition,
  })  : assert(viewportFraction > 0.0, 'Viewport fraction should be more then 0'),
        _viewportFraction = viewportFraction,
        _pageToUseOnStartup = initialPage.toDouble(),
        super(
          initialPixels: null,
          keepScrollOffset: keepPage,
        );

  @override
  Future<void> ensureVisible(
    RenderObject object, {
    double alignment = 0.0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy = ScrollPositionAlignmentPolicy.explicit,
    RenderObject? targetRenderObject,
  }) =>
      // Since the _PagePosition is intended to cover the available space within
      // its viewport, stop trying to move the target render object to the center
      // - otherwise, could end up changing which page is visible and moving the
      // targetRenderObject out of the viewport.
      super.ensureVisible(
        object,
        alignment: alignment,
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
      );

  @override
  double get viewportFraction => _viewportFraction;
  set viewportFraction(double value) {
    if (_viewportFraction == value) {
      return;
    }
    final double? oldPage = page;
    _viewportFraction = value;
    if (oldPage != null) {
      forcePixels(getPixelsFromPage(oldPage));
    }
  }

  // The amount of offset that will be added to [minScrollExtent] and subtracted
  // from [maxScrollExtent], such that every page will properly snap to the center
  // of the viewport when viewportFraction is greater than 1.
  //
  // The value is 0 if viewportFraction is less than or equal to 1, larger than 0
  // otherwise.
  double get _initialPageOffset => max(0, viewportDimension * (viewportFraction - 1) / 2);

  /// Calculates an additional directional offset based on the current scroll position.
  ///
  /// - [pagePadding]: The padding applied to the pages in the viewport.
  ///
  /// This method determines if the current scroll position is near the start
  /// or end of the scrollable range, and adjusts the offset to maintain proper
  /// alignment.
  double directionalOffset(double pagePadding) {
    if (!hasContentDimensions) {
      return 0.0;
    }

    final paddingOffset = pagePadding - separationWidth;

    if ((maxScrollExtent - viewportDimension * viewportFraction / 2) < pixels) {
      return paddingOffset;
    } else if (viewportDimension * viewportFraction / 2 > pixels) {
      return -paddingOffset;
    }

    return 0.0;
  }

  /// Calculates the page index from a given pixel offset.
  ///
  /// - [pixels]: The scroll offset in pixels.
  /// - [viewportDimension]: The size of the viewport.
  double getPageFromPixels(double pixels, double viewportDimension) {
    final pagePadding = (viewportDimension - viewportDimension * viewportFraction) / 2;

    final pagePosition =
        pixels - _initialPageOffset + (pagePadding - horizontalPadding) + directionalOffset(pagePadding);

    final double actual = max(0.0, pagePosition) / (viewportDimension * viewportFraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  /// Converts a page index to its corresponding pixel offset.
  ///
  /// - [page]: The page index to convert.
  double getPixelsFromPage(double page) {
    final pagePadding = (viewportDimension - viewportDimension * viewportFraction) / 2;
    final clampDouble2 = clampDouble(
      page * viewportDimension * viewportFraction - pagePadding + horizontalPadding + _initialPageOffset,
      0,
      hasContentDimensions ? maxScrollExtent : double.infinity,
    );

    return clampDouble2;
  }

  @override
  double? get page {
    assert(
      !hasPixels || hasContentDimensions,
      'Page value is only available after content dimensions are established.',
    );
    return !hasPixels || !hasContentDimensions
        ? null
        : _cachedPage ?? getPageFromPixels(clampDouble(pixels, minScrollExtent, maxScrollExtent), viewportDimension);
  }

  @override
  void saveScrollOffset() {
    PageStorage.maybeOf(context.storageContext)
        ?.writeState(context.storageContext, _cachedPage ?? getPageFromPixels(pixels, viewportDimension));
  }

  @override
  void restoreScrollOffset() {
    if (!hasPixels) {
      final double? value = PageStorage.maybeOf(context.storageContext)?.readState(context.storageContext) as double?;
      if (value != null) {
        _pageToUseOnStartup = value;
      }
    }
  }

  @override
  void saveOffset() {
    context.saveOffset(_cachedPage ?? getPageFromPixels(pixels, viewportDimension));
  }

  @override
  void restoreOffset(double offset, {bool initialRestore = false}) {
    if (initialRestore) {
      _pageToUseOnStartup = offset;
    } else {
      jumpTo(getPixelsFromPage(offset));
    }
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions = hasViewportDimension ? this.viewportDimension : null;
    if (viewportDimension == oldViewportDimensions) {
      return true;
    }
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = hasPixels ? pixels : null;
    double page;
    if (oldPixels == null) {
      page = _pageToUseOnStartup;
    } else if (oldViewportDimensions == 0.0) {
      // If resize from zero, we should use the _cachedPage to recover the state.
      page = _cachedPage!;
    } else {
      page = getPageFromPixels(oldPixels, oldViewportDimensions!);
    }
    final double newPixels = getPixelsFromPage(page);

    // If the viewportDimension is zero, cache the page
    // in case the viewport is resized to be non-zero.
    _cachedPage = (viewportDimension == 0.0) ? page : null;

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }
    return result;
  }

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);

    if (other is! SliderPosition) {
      return;
    }

    if (other._cachedPage != null) {
      _cachedPage = other._cachedPage;
    }
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final double newMinScrollExtent = minScrollExtent + _initialPageOffset;
    return super.applyContentDimensions(
      newMinScrollExtent,
      max(newMinScrollExtent, maxScrollExtent - _initialPageOffset),
    );
  }

  @override
  PageMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? viewportFraction,
    double? devicePixelRatio,
  }) =>
      PageMetrics(
        minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
        maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
        pixels: pixels ?? (hasPixels ? this.pixels : null),
        viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
        axisDirection: axisDirection ?? this.axisDirection,
        viewportFraction: viewportFraction ?? this.viewportFraction,
        devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      );
}
