import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Custom scroll physics for a [PageView] that provides enhanced sensitivity
/// and smooth page transitions.
///
/// This physics class allows for fine-tuning the responsiveness of page
/// flinging and snapping behavior. It uses a configurable velocity threshold
/// and spring simulation to achieve smooth animations.
class CustomScrollPhysics extends ScrollPhysics {
  /// The minimum velocity required to trigger a page flip.
  ///
  /// A lower value makes the page view more sensitive to flings.
  final double velocityThreshold;

  /// The spring simulation used for page transition animations.
  ///
  /// Adjust the mass, stiffness, and damping to customize the animation feel.
  @override
  final SpringDescription spring;

  /// Creates a [CustomScrollPhysics] for use in a [PageView].
  ///
  /// - [parent]: The parent scroll physics to inherit from.
  /// - [velocityThreshold]: The minimum velocity to trigger a page flip.
  /// - [spring]: The spring simulation for page transitions.
  const CustomScrollPhysics({
    super.parent,
    this.velocityThreshold = 50,
    this.spring = const SpringDescription(
      mass: 0.5,
      stiffness: 250,
      damping: 25,
    ),
  });

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) => CustomScrollPhysics(
        parent: buildParent(ancestor),
        velocityThreshold: velocityThreshold,
        spring: spring,
      );

  /// Calculates the current page based on the scroll position.
  ///
  /// - [position]: The current scroll metrics.
  /// - Returns: The current page as a double.
  double _getPage(ScrollMetrics position) {
    if (position is _Position) {
      return position.page!;
    }
    return position.pixels / position.viewportDimension;
  }

  /// Converts a page number to a pixel offset.
  ///
  /// - [position]: The current scroll metrics.
  /// - [page]: The target page number.
  /// - Returns: The pixel offset corresponding to the page.
  double _getPixels(ScrollMetrics position, double page) {
    if (position is _Position) {
      return position.getPixelsFromPage(page);
    }
    return page * position.viewportDimension;
  }

  /// Determines the target pixel offset based on the current velocity.
  ///
  /// - [position]: The current scroll metrics.
  /// - [tolerance]: The tolerance for velocity and distance.
  /// - [velocity]: The current scroll velocity.
  /// - Returns: The target pixel offset.
  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    }
    return null;
  }

  @override
  Tolerance toleranceFor(ScrollMetrics metrics) => const Tolerance(
        velocity: 25,
        distance: 10,
      );

  @override
  bool get allowImplicitScrolling => false;
}

/// A scroll position that manages page-based scrolling for a [PageView].
///
/// This class handles the logic for converting between page numbers and pixel
/// offsets, and ensures that pages snap correctly to their positions.
class _Position extends ScrollPositionWithSingleContext implements PageMetrics {
  /// Creates a [_PagePosition] for use in a [PageView].
  ///
  /// - [physics]: The scroll physics to use.
  /// - [context]: The scroll context.
  /// - [initialPage]: The initial page to display.
  /// - [keepPage]: Whether to save and restore the current page.
  /// - [viewportFraction]: The fraction of the viewport each page occupies.
  /// - [oldPosition]: The previous scroll position, if any.
  _Position({
    required super.physics,
    required super.context,
    this.initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  })  : assert(viewportFraction > 0.0, 'must be greater then zero'),
        _viewportFraction = viewportFraction,
        _pageToUseOnStartup = initialPage.toDouble(),
        super(
          initialPixels: null,
          keepScrollOffset: keepPage,
        );

  /// The initial page to display when the view is first created.
  final int initialPage;

  /// The page to use when the viewport is first initialized.
  double _pageToUseOnStartup;

  /// The cached page value, used when the viewport size is zero.
  double? _cachedPage;

  /// Since the _PagePosition is intended to cover the available space within
  /// its viewport, stop trying to move the target render object to the center
  /// - otherwise, could end up changing which page is visible and moving the
  /// targetRenderObject out of the viewport.
  @override
  Future<void> ensureVisible(
    RenderObject object, {
    double alignment = 0.0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy = ScrollPositionAlignmentPolicy.explicit,
    RenderObject? targetRenderObject,
  }) =>
      super.ensureVisible(
        object,
        alignment: alignment,
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
      );

  @override
  double get viewportFraction => _viewportFraction;
  double _viewportFraction;

  /// Sets the fraction of the viewport that each page occupies.
  ///
  /// - [value]: The new viewport fraction.
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

  /// The initial page offset, used to center pages when [viewportFraction] > 1.
  double get _initialPageOffset => math.max(0, viewportDimension * (viewportFraction - 1) / 2);

  /// Converts a pixel offset to a page number.
  ///
  /// - [pixels]: The pixel offset.
  /// - [viewportDimension]: The size of the viewport.
  /// - Returns: The corresponding page number.
  double getPageFromPixels(double pixels, double viewportDimension) {
    assert(viewportDimension > 0.0, 'must be more then zero');
    final double actual = math.max(0.0, pixels - _initialPageOffset) / (viewportDimension * viewportFraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  /// Converts a page number to a pixel offset.
  ///
  /// - [page]: The page number.
  /// - Returns: The corresponding pixel offset.
  double getPixelsFromPage(double page) => page * viewportDimension * viewportFraction + _initialPageOffset;

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
    assert(_cachedPage == null, 'must be null');
    if (other is! _Position) {
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
      math.max(newMinScrollExtent, maxScrollExtent - _initialPageOffset),
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
