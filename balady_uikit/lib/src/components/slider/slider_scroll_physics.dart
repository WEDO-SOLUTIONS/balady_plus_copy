import 'package:flutter/material.dart';

/// A custom scroll physics class to provide snapping behavior for a paginated slider.
///
/// The [SliderScrollPhysics] ensures that items in the slider snap into place,
/// even during rapid scrolling or when scrolling beyond bounds.
class SliderScrollPhysics extends ScrollPhysics {
  /// Padding around the slider's scrollable area.
  final double padding;

  /// The spacing between items in the slider.
  final double separationWidth;

  /// The size of an individual item in the slider.
  final double itemSize;

  /// Creates a custom scroll physics instance for slider widgets.
  ///
  /// [padding], [separationWidth], and [itemSize] must be provided.
  const SliderScrollPhysics({
    required this.padding,
    required this.separationWidth,
    required this.itemSize,
  }) : super(parent: const BouncingScrollPhysics());

  /// Determines if implicit scrolling is allowed.
  ///
  /// This is always `false` in [SliderScrollPhysics] to ensure precise snapping.
  @override
  bool get allowImplicitScrolling => false;

  /// Applies this physics object to an optional ancestor.
  ///
  /// This allows for chaining of physics behaviors, where the [ancestor]
  /// represents parent physics. A new instance of [SliderScrollPhysics] is returned.
  @override
  SliderScrollPhysics applyTo(ScrollPhysics? ancestor) => SliderScrollPhysics(
        itemSize: itemSize,
        padding: padding,
        separationWidth: separationWidth,
      );

  /// Creates a simulation to determine how the slider settles after user interaction.
  ///
  /// If the scroll position is out of bounds and the velocity suggests
  /// movement away from valid bounds, this delegates to the parent physics. Otherwise,
  /// it ensures snapping behavior by calculating the nearest valid position and animating
  /// the slider to it.
  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Handle out-of-bounds conditions by delegating to parent physics.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    // Define tolerances for snapping behavior.
    final tolerance = toleranceFor(position);

    // Calculate padding to center items in the viewport.
    final contentPadding = (position.extentInside - itemSize) / 2;

    // Determine the target position for snapping.
    final endPosition = getEndPosition(position, tolerance, velocity, contentPadding) + padding;

    // If the target position differs from the current position, create a spring simulation.
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

  /// Calculates the snapping position based on velocity and content alignment.
  ///
  /// This determines the nearest valid position for an item in the slider to snap to.
  ///
  /// - [position]: The current scroll metrics.
  /// - [tolerance]: The tolerance values for snapping.
  /// - [velocity]: The current scroll velocity.
  /// - [contentPadding]: Padding used to center items in the viewport.
  double getEndPosition(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
    double contentPadding,
  ) {
    // Offset adjustment based on velocity direction.
    double offset() {
      if (velocity < -tolerance.velocity) {
        return -0.5;
      } else if (velocity > tolerance.velocity) {
        return 0.5;
      }
      return 0.0;
    }

    // Calculate the target item's index and position based on scroll metrics and velocity.
    final itemIndex =
        ((position.pixels + contentPadding - padding + separationWidth / 2) / itemSize + offset()).roundToDouble();

    return (itemIndex * itemSize) - contentPadding - separationWidth / 2;
  }
}
