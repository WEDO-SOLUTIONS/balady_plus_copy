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
import 'package:mapness/widgets/parking_spot/parking_control.dart';
import 'package:mapness/widgets/weather/weather_control.dart';

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

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<double>(
        valueListenable: _bottomPadding,
        builder: (context, bottomPadding, child) {
          final freeRoamState = ref.watch(freeRoamStarterProvider);
          final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
          final controlsHeight = 56 + (showLaunchingFreeRoam ? 8 : 0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
                  child: OverflowBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: uikit.Spacing.$3x,
                        top: uikit.Spacing.$3x,
                        right: uikit.Spacing.$3x,
                      ),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
}
