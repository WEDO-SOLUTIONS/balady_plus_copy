import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/eta_sharing_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class MapDashboardControls extends ConsumerStatefulWidget {
  final uikit.StatefulBottomSheetController scrollController;

  const MapDashboardControls(
    this.scrollController, {
    super.key,
  });

  @override
  ConsumerState<MapDashboardControls> createState() => _MapDashboardControlsState();
}

class _MapDashboardControlsState extends ConsumerState<MapDashboardControls> {
  late ValueNotifier<double> _bottomPadding;

  @override
  void initState() {
    super.initState();
    _bottomPadding = ValueNotifier(widget.scrollController.sheetHeight);
    widget.scrollController.addListener(update);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TODO(Ayat): There are problems that the bottom shield does not have time to draw and this is a temporary fix for now temporary fix
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(update);
    _bottomPadding.dispose();
    super.dispose();
  }

  void update() {
    _bottomPadding.value = widget.scrollController.sheetHeight;
  }

  bool _shouldHideControls(double screenHeight) {
    final freeRoamState = ref.watch(freeRoamStarterProvider);
    final isGoToNavigatorShown = freeRoamState.canStart && !freeRoamState.isAutorun;

    final isSheetCoversHalfOfTheScreen =
        widget.scrollController.viewportHeight < _bottomPadding.value + screenHeight / 2;
    final isSheetStateOpen = widget.scrollController.state == uikit.ThreeStateBottomSheet.open;
    final isSheetScrolledForHalfOfTheState = widget.scrollController.interpolation > 0.5;

    return isGoToNavigatorShown ||
        (!widget.scrollController.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
        isSheetCoversHalfOfTheScreen;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<double>(
        valueListenable: _bottomPadding,
        builder: (context, bottomPadding, child) {
          final freeRoamState = ref.watch(freeRoamStarterProvider);
          final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
          final controlsHeight = 56 + (showLaunchingFreeRoam ? 8 : 0);
          final screenHeight = MediaQuery.of(context).size.height;

          final bool areControlsVisible =
              !_shouldHideControls(screenHeight) && widget.scrollController.viewportHeight > bottomPadding + 200;

          return SizedBox(
            height: screenHeight,
            child: Visibility(
              visible: areControlsVisible,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Expanded(
                        child: OverflowBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: uikit.Spacing.$3x,
                              top: uikit.Spacing.$3x,
                              right: uikit.Spacing.$3x,
                              bottom: bottomPadding == 0 ? widget.scrollController.sheetHeight : bottomPadding,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    const IndoorControl(),
                                    const Spacer(),
                                    const EtaSharingControl(),
                                    uikit.Spacing.$4x.heightBox,
                                    SizedBox(
                                      height: widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden
                                          ? controlsHeight * (1 - widget.scrollController.interpolation)
                                          : 0,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const LayersControl(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    const TrafficControl(),
                                    const Spacer(),
                                    const ZoomControl(),
                                    const Spacer(),
                                    const CompassControl(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    ComplianceBuildingLegend(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    const FollowControl(),
                                    uikit.Spacing.$4x.heightBox,
                                    SizedBox(
                                      height: widget.scrollController.state == uikit.ThreeStateBottomSheet.hidden
                                          ? controlsHeight * (1 - widget.scrollController.interpolation)
                                          : 0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
