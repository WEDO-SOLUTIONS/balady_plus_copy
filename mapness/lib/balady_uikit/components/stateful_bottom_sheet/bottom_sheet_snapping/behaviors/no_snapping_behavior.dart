import 'dart:collection';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_snapping/models/no_snapping_model.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

/// Controls the behavior of the bottom sheet when scrolling.
///
/// It provides information for the bottom sheet to scroll inside a bounding box freely without any snapping.
final class NoSnappingBehavior extends SnappingBehavior {
  final NoSnappingModel model;

  NoSnappingBehavior({double? offsetFromTop, double? offsetFromBottom})
      : model = NoSnappingModel(minPosition: offsetFromTop, maxPositionOffset: offsetFromBottom);

  @override
  bool get shouldSnap => false;

  @override
  bool get needsSetup => !hasSizes;

  @override
  double get minOffset => _minOffset;
  double _minOffset = 0.0;

  @override
  double get maxOffset => _maxOffset;
  double _maxOffset = 0.0;

  @override
  int anchoredState<T>(BottomSheetStatefulExtent<T> extent) => 0;

  @override
  void setup<T>(BottomSheetStatefulExtent<T> extent) {
    super.setup(extent);
    avaliableSpace = extent.availablePixels;
    _minOffset = model.lowerBound(extent);
    _maxOffset = model.upperBound(extent);
  }

  @override
  SplayTreeSet<double>? performSetup<T>(BottomSheetStatefulExtent<T> extent) => null;
}
