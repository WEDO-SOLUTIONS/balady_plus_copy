import 'dart:collection';
import 'dart:ui';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_snapping/models/bottom_sheet_snapping_models.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';
import 'package:urbi_utils/urbi_utils.dart';

/// Snapping model that calculates snapping positions based on aspect ratios of the bottom sheet's viewport.
///
/// This model defines snapping offsets as proportions of the viewport's height,
/// allowing for dynamic adjustments based on the available space. It is used with
/// the bottom sheet's [SnappingBehavior] to provide aspect ratio-based snapping states.
final class AspectRatioSnappingModel extends BottomSheetSnappingModel {
  /// A set of aspect ratios where:
  /// - `0` represents the bottom of the viewport.
  /// - `1` represents the top of the viewport.
  ///
  /// Each aspect ratio defines a relative snapping position as a proportion of the available viewport height.
  final Set<double> aspectRatios;

  /// Constructs an [AspectRatioSnappingModel] with the given [aspectRatios].
  ///
  /// - [aspectRatios]: A set of aspect ratios defining snapping positions. Each value should
  ///   fall between `0.0` (bottom of the viewport) and `1.0` (top of the viewport).
  ///
  /// ### Usage Example:
  /// ```dart
  /// // Define snapping positions at 25%, 50%, and 75% of the viewport height.
  /// final snappingModel = AspectRatioSnappingModel({0.25, 0.5, 0.75});
  /// ```
  AspectRatioSnappingModel(this.aspectRatios);

  /// Calculates snapping offsets based on the aspect ratios of the viewport.
  ///
  /// - [extent]: The current state of the bottom sheet.
  /// - Returns a sorted set of snapping offsets, where each offset is a clamped value derived
  ///   from the aspect ratios and the available pixels.
  @override
  SplayTreeSet<double> getOffsets<T>(BottomSheetStatefulExtent<T> extent) => SplayTreeSet.of(aspectRatios.map(
      (ar) => clampDouble(((1 - ar) * extent.availablePixels).roundDecimal(), extent.minOffset, extent.safeMaxOffset)));
}
