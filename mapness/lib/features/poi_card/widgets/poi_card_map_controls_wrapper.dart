import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls.dart';

class PoiCardMapControlsWrapper extends StatelessWidget {
  final StatefulBottomSheetController<PoiCardBottomSheetState> bottomSheetController;

  const PoiCardMapControlsWrapper({
    required this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: bottomSheetController,
        builder: (context, child) {
          if (child == null) {
            return const SizedBox.shrink();
          }
          final state = bottomSheetController.state;
          final interpolation = bottomSheetController.interpolation;

          final hideControls = state.index + interpolation > PoiCardBottomSheetState.halfOpen.index;
          final opacity =
              hideControls ? max(0.0, 1 - state.index + (1 - Curves.decelerate.transform(interpolation) * 3)) : 1.0;

          if (opacity == 0.0) {
            return const SizedBox.shrink();
          }

          final height = MediaQuery.sizeOf(context).height;
          return IgnorePointer(
            ignoring: hideControls,
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                height: height - bottomSheetController.sheetHeight - bottomSheetController.componentSizes.topHeader,
                child: child,
              ),
            ),
          );
        },
        child: const PoiCardMapControls(),
      );
}
