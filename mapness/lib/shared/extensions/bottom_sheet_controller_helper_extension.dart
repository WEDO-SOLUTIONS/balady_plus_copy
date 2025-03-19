import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';

extension StatefulBottomSheetControllerEx<T> on StatefulBottomSheetController<T> {
  double Function(StatefulBottomSheetController<ThreeStateBottomSheet>)? get defaultOpacityDelegate => (controller) {
        final aspectRatio = controller.aspectRatio;
        final interpolation = controller.interpolation;
        final state = controller.state;

        final isSheetCoversHalfOfTheScreen = aspectRatio > 0.4;
        final isSheetStateOpen = state == ThreeStateBottomSheet.open;
        final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

        final isFull = (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
            isSheetCoversHalfOfTheScreen;

        return !isFull ? 1.0 : max(0.0, 1 - (aspectRatio - 0.4) * 9);
      };
}
