import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls.dart';

class PoiCardMapControlsWrapper extends StatefulWidget {
  final StatefulBottomSheetController<PoiCardBottomSheetState> bottomSheetController;

  const PoiCardMapControlsWrapper({
    required this.bottomSheetController,
    super.key,
  });

  @override
  State<PoiCardMapControlsWrapper> createState() => _PoiCardMapControlsWrapperState();
}

class _PoiCardMapControlsWrapperState extends State<PoiCardMapControlsWrapper> with TickerProviderStateMixin {
  final ValueNotifier<bool> ignoreControls = ValueNotifier(false);
  late final AnimationController opacityAnimation;

  @override
  void initState() {
    opacityAnimation = AnimationController(vsync: this, value: 1.0);
    widget.bottomSheetController.addListener(updateOpacity);

    super.initState();
  }

  void updateOpacity() {
    final state = widget.bottomSheetController.state;
    final interpolation = widget.bottomSheetController.interpolation;

    ignoreControls.value = state.index + interpolation > PoiCardBottomSheetState.halfOpen.index;
    final opacity =
        ignoreControls.value ? max(0.0, 1 - state.index + (1 - Curves.decelerate.transform(interpolation) * 3)) : 1.0;
    opacityAnimation.value = opacity;
  }

  @override
  void didUpdateWidget(PoiCardMapControlsWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bottomSheetController == widget.bottomSheetController) {
      return;
    }

    oldWidget.bottomSheetController.removeListener(updateOpacity);
    widget.bottomSheetController.addListener(updateOpacity);

    updateOpacity();
  }

  @override
  void dispose() {
    widget.bottomSheetController.removeListener(updateOpacity);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: ignoreControls,
        builder: (context, ignore, child) => IgnorePointer(
          ignoring: ignore,
          child: child,
        ),
        child: FadeTransition(
          opacity: opacityAnimation,
          child: const PoiCardMapControls(),
        ),
      );
}
