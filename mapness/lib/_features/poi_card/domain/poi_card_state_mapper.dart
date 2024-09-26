import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/enums/poi_card_bottom_sheet_state.dart';

final class PoiCardStateMapper implements BottomSheetStateMapper<PoiCardBottomSheetState> {
  const PoiCardStateMapper();

  @override
  PoiCardBottomSheetState state(int state) =>
      PoiCardBottomSheetState.values.elementAtOrNull(state) ?? PoiCardBottomSheetState.expanded;

  @override
  int index(PoiCardBottomSheetState state) => state.index;

  @override
  bool shouldPopOn(StatefulBottomSheetController<PoiCardBottomSheetState> controller) {
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
  static Color? backgroundColorDelegate(FourStateBottomSheet state, double interpolation) {
    if (state == FourStateBottomSheet.hidden || state == FourStateBottomSheet.expanded) {
      return null;
    }

    if (state == FourStateBottomSheet.open) {
      return Colors.black.withOpacity(max(0.0, state.index - interpolation * 2 - 1) * 0.7);
    }

    return Colors.black.withOpacity((state.index + interpolation - 1) * 0.7);
  }
}
