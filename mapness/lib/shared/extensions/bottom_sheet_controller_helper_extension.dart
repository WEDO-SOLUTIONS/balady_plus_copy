import 'dart:math';

import 'package:sheetify/sheetify.dart';

extension MultiStateSheetControllerEx on MultiStateSheetController<ThreeStateSheet> {
  StatefulSheetDelegateFunction<double, ThreeStateSheet>? get defaultOpacityDelegate =>
      StatefulSheetDelegateFunction(function: (controller) {
        final fraction = controller.fraction;
        final interpolation = controller.interpolation;
        final state = controller.state;

        final isSheetCoversHalfOfTheScreen = fraction > 0.4;
        final isSheetStateOpen = state == ThreeStateSheet.open;
        final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

        final isFull = (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
            isSheetCoversHalfOfTheScreen;

        return !isFull ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
      });
}
