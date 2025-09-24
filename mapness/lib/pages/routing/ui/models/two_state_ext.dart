import 'dart:math';

import 'package:mapness/pages/routing/route_details_state_mapper.dart';
import 'package:sheetify/sheetify.dart';

extension MultiStateSheetControllerEx on MultiStateSheetController<TwoStateSheet> {
  StatefulSheetDelegateFunction<double, TwoStateSheet>? get defaultOpacityDelegate =>
      StatefulSheetDelegateFunction(function: (controller) {
        final fraction = controller.fraction;
        final interpolation = controller.interpolation;
        final state = controller.state;

        final isSheetCoversHalfOfTheScreen = fraction > 0.4;
        final isSheetStateOpen = state == TwoStateSheet.expanded;
        final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

        final isFull = (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
            isSheetCoversHalfOfTheScreen;

        return !isFull ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
      });
}
