import 'package:balady_uikit/balady_uikit.dart' show RadiusBorder;
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:sheetify/sheetify.dart';

final class PoiCardStateMapper implements SheetStateMapper<PoiCardBottomSheetState> {
  const PoiCardStateMapper();

  @override
  PoiCardBottomSheetState state(int state) =>
      PoiCardBottomSheetState.values.elementAtOrNull(state) ?? PoiCardBottomSheetState.expanded;

  @override
  int index(PoiCardBottomSheetState state) => state.index;

  /// Full-height state of the sheet. Without the photo snap offset the ladder has
  /// only three offsets, so [PoiCardBottomSheetState.expanded] does not exist there.
  static PoiCardBottomSheetState fullState({required bool hasPhotoSnap}) =>
      hasPhotoSnap ? PoiCardBottomSheetState.expanded : PoiCardBottomSheetState.open;

  @override
  bool shouldPopOn(MultiStateSheetController<PoiCardBottomSheetState> controller) {
    switch (controller.closestState) {
      case PoiCardBottomSheetState.hidden:
        controller.reset();
        return true;

      case PoiCardBottomSheetState.halfOpen:
        controller.setState(PoiCardBottomSheetState.hidden);
        return false;
      case PoiCardBottomSheetState.open:
        controller.setState(PoiCardBottomSheetState.halfOpen);
        return false;

      case PoiCardBottomSheetState.expanded:
        controller.setState(PoiCardBottomSheetState.open);
        return false;
    }
  }

  /// Delegate method for calculate background fill color inside bottom sheet.
  static const StatefulSheetDelegateFunction<Color?, PoiCardBottomSheetState> barrierColorDelegate =
      StatefulSheetDelegateFunction(function: _barrierColorDelegate);

  static Color? _barrierColorDelegate(MultiStateSheetController<PoiCardBottomSheetState> controller) {
    final state = controller.state;
    final interpolation = controller.interpolation;

    if (state == PoiCardBottomSheetState.hidden) {
      return null;
    }

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return Colors.black.withOpacity(0.4);
    }

    final opacity = interpolation * 0.4;
    return Colors.black.withOpacity(opacity);
  }

  static const StatefulSheetDelegateFunction<double, PoiCardBottomSheetState> topHeaderOffsetDelegate =
      StatefulSheetDelegateFunction(function: _topHeaderOffsetDelegate);

  static double _topHeaderOffsetDelegate(MultiStateSheetController<PoiCardBottomSheetState> controller) {
    final state = controller.state;
    final interpolation = controller.interpolation;

    if (state != PoiCardBottomSheetState.halfOpen) {
      return 0;
    }

    return -RadiusBorder.xl * interpolation;
  }
}
