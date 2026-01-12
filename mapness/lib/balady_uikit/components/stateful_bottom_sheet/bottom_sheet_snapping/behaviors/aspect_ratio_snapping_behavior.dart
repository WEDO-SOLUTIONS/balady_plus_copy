import 'dart:collection';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_snapping/models/aspect_ratio_snapping_model.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

/// Controls the snapping behavior of a bottom sheet based on aspect ratios of its bounding box.
///
/// This behavior defines snapping positions for the bottom sheet by calculating offsets
/// relative to specified aspect ratios of the viewport. It ensures smooth transitions
/// between states and provides boundaries for the minimum and maximum offsets.
final class AspectRatioSnappingBehavior<StateType> extends SnappingBehavior {
  /// The set of aspect ratios used to determine snapping positions.
  ///
  /// Each aspect ratio is a value between `0.0` (bottom of the viewport) and `1.0` (top of the viewport).
  final Set<double> aspectRatios;

  /// The snapping model used to calculate offsets based on aspect ratios.
  final AspectRatioSnappingModel model;

  /// Constructs an [AspectRatioSnappingBehavior] with the specified [aspectRatios].
  ///
  /// - [aspectRatios]: A set of aspect ratios defining snapping states. Must contain at least two ratios.
  ///
  /// ### Example:
  /// ```dart
  /// AspectRatioSnappingBehavior(aspectRatios: {0.25, 0.5, 0.75});
  /// ```
  ///
  /// Throws an [AssertionError] if fewer than two aspect ratios are provided.
  AspectRatioSnappingBehavior({
    required this.aspectRatios,
    super.clipByHeader,
  })  : assert(aspectRatios.length >= 2, 'AspectRatios must contain at least 2 snapping states'),
        model = AspectRatioSnappingModel(aspectRatios.toSet());

  @override
  SplayTreeSet<double>? performSetup<T>(BottomSheetStatefulExtent<T> extent) => model.getOffsets(extent);
}
