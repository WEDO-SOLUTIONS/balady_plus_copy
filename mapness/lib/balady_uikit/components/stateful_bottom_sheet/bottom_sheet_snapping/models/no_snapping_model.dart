import 'dart:collection';
import 'dart:math';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_snapping/models/bottom_sheet_snapping_models.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

/// Snapping model which is using pixel positions to calculate snapping positions and it's states.
///
/// This model is used inside the bottom sheet [SnappingBehavior] UX objects.
final class NoSnappingModel extends BottomSheetSnappingModel {
  /// Start position of the the no snapping area from the bottom of the screen.
  final double? minPosition;

  /// Offset from the top of the screen of no snapping area.
  final double? maxPositionOffset;

  const NoSnappingModel({this.minPosition, this.maxPositionOffset});

  /// Returns the lower bound of the bounding box.
  double lowerBound<T>(BottomSheetStatefulExtent<T> extent) {
    final _minPosition = minPosition;
    if (_minPosition == null) {
      return 0;
    }

    return max(0, _minPosition);
  }

  /// Returns the higher bound of the bounding box.
  double upperBound<T>(BottomSheetStatefulExtent<T> extent) {
    final _maxPositionOffset = maxPositionOffset;
    final maxHeight = extent.availablePixels - extent.initialComponentSizes.header;
    if (_maxPositionOffset == null) {
      return maxHeight;
    }

    return min(maxHeight, extent.availablePixels - _maxPositionOffset);
  }

  @override
  SplayTreeSet<double> getOffsets<T>(BottomSheetStatefulExtent<T> extent, {List<double>? positions}) =>
      SplayTreeSet.of({lowerBound(extent), upperBound(extent)});
}
