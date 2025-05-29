import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/eta_sharing_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/parking_spot/parking_control.dart';
import 'package:mapness/widgets/weather/weather_control.dart';

class MapDashboardControls extends ConsumerStatefulWidget {
  final uikit.StatefulBottomSheetController<uikit.ThreeStateBottomSheet> scrollController;

  const MapDashboardControls(
    this.scrollController, {
    super.key,
  });

  @override
  ConsumerState<MapDashboardControls> createState() => _MapDashboardControlsState();
}

class _MapDashboardControlsState extends ConsumerState<MapDashboardControls> {
  final _hideControllerNotifier = ValueNotifier<bool>(false);

  double? startSheetHeight;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(update);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        startSheetHeight = widget.scrollController.sheetHeight;
      },
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(update);
    _hideControllerNotifier.dispose();
    super.dispose();
  }

  void update() {
    if (startSheetHeight != null) {
      _hideControllerNotifier.value = startSheetHeight! < widget.scrollController.sheetHeight;
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _hideControllerNotifier,
        builder: (context, isHide, child) => AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: isHide
              ? const SizedBox.shrink()
              : Builder(
                  builder: (context) {
                    final freeRoamState = ref.watch(freeRoamStarterProvider);
                    final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
                    final controlsHeight = 56 + (showLaunchingFreeRoam ? 8 : 0);

                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: uikit.Spacing.$3x,
                          top: uikit.Spacing.$3x,
                          right: uikit.Spacing.$3x,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const WeatherControl(),
                                          uikit.Spacing.$1_5x.heightBox,
                                          const ParkingControl(),
                                        ],
                                      ),
                                      const Spacer(),
                                      const IndoorControl(),
                                      const Spacer(),
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
                                      const SizedBox(height: uikit.Spacing.$2x),
                                      const DimensionControl(),
                                      const SizedBox(height: uikit.Spacing.$2x),
                                      const Spacer(),
                                      const ZoomControl(),
                                      const Spacer(),
                                      const CompassControl(),
                                      const SizedBox(height: uikit.Spacing.$2x),
                                      ComplianceBuildingLegend(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: uikit.Spacing.$2x),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EtaSharingControl(),
                                FollowControl(),
                              ],
                            ),
                            uikit.Spacing.$4x.heightBox,
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
}
