import 'dart:collection';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_snapping/models/size_snapping_model.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

/// Snapping behavior which is using `bottom sheet sizes` in pixels to calculate snapping offsets and it's states.
///
/// Controls the behavior of the bottom sheet when scrolling or dragging.
///
/// It provides information to the bottom sheet to bind the sheet to a specific size for each state.
/// If the provided size exceeds the size of the viewport it will be clamped to the size of the viewport.
final class SizeSnappingBehavior extends SnappingBehavior {
  final Set<double> sizes;
  final SizeSnappingModel model;

  /// Snapping behavior which is using `bottom sheet sizes` in pixels to calculate snapping offsets and it's states.
  ///
  /// Controls the behavior of the bottom sheet when scrolling or dragging.
  ///
  /// It provides information to the bottom sheet to bind the sheet to a specific size for each state.
  /// If the provided `size` exceeds the `size of the viewport` it will be clamped to the `size of the viewport`.
  ///
  /// ## Usage
  ///
  /// ```dart
  /// StatefulBottomSheetController(
  ///   stateMapper: const FourStateMapper(),
  ///   initialState: FourStateBottomSheet.halfOpen,
  ///   behavior: SizeSnappingBehavior(sizes: {0, 400, 600, 900}),
  /// );
  /// ```
  SizeSnappingBehavior({
    required this.sizes,
    super.clipByHeader,
  }) : model = SizeSnappingModel(sizes);

  @override
  SplayTreeSet<double>? performSetup<T>(BottomSheetStatefulExtent<T> extent) => model.getOffsets(extent);
}
