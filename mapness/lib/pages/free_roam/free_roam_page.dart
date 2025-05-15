import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/free_roam/free_roam_manager.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/free_roam/ui/road_panel.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/path_nav_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_sheet.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

@RoutePage()
class FreeRoamPage extends ConsumerStatefulWidget {
  const FreeRoamPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FreeRoamPageState();
}

class FreeRoamPageState extends ConsumerState<FreeRoamPage> {
  static const padding = EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x);

  bool isLoading = true;

  bool isControlsActive = true;
  bool wasSetActive = true;

  Timer? timer;

  StreamSubscription? _naviEventsListener;

  late final uikit.StatelessBottomSheetController _bottomSheetController = uikit.StatelessBottomSheetController(
    onClose: (_) => _bottomSheetController.close,
  );

  @override
  void initState() {
    super.initState();
    ref.read(freeRoamManagerProvider.notifier).initFreeRoam().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    startControlsDisapearTimer();
    _listenNavigationEvents();

    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    ref.read(freeRoamManagerProvider.notifier).deactivate();
    super.deactivate();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _naviEventsListener?.cancel();
    super.dispose();
  }

  Future<void> _listenNavigationEvents() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _naviEventsListener = dgisController.navigationEvents.listen((event) {
      if (event == NavigationEvent.disabled && context.mounted) {
        ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context);
      }
    });
  }

  void startControlsDisapearTimer() {
    timer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          isControlsActive = false;
          wasSetActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemDirectionality = Directionality.of(context);
    return SafeArea(
      bottom: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                timer?.cancel();
                timer = null;
                setState(() {
                  if (!isControlsActive) {
                    wasSetActive = true;
                    isControlsActive = true;
                  }
                });
              },
              onPointerUp: (event) {
                startControlsDisapearTimer();
              },
            ),
            GestureDetector(
              behavior: isControlsActive ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  if (wasSetActive) {
                    wasSetActive = false;
                    return;
                  }

                  isControlsActive = !isControlsActive;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: uikit.Spacing.$1_5x, width: double.maxFinite),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final message = ref.watch(pathNavMessageProvider);
                      final maneuver = ref.watch(pathNavManeuverProvider);
                      final info = ref.watch(pathNavSpeedInfoProvider);

                      return Material(
                        type: MaterialType.transparency,
                        color: Colors.transparent,
                        child: uikit.BaladyManeuverAndLimit(
                          isPedestrian: false,
                          hideSpeedLimit: info.speedLimit == null,
                          speedInfo: uikit.LimitsModel(
                            speed: info.speed,
                            speedExceed: info.speedExceed,
                            speedLimit: info.speedLimit,
                          ),
                          maneuver: maneuver != null
                              ? uikit.BaladyManeuverModel(
                                  distance: maneuver.distance,
                                  instruction: maneuver.instruction?.toUIKit(),
                                  roadName: maneuver.roadName,
                                  unit: maneuver.unit,
                                )
                              : null,
                          message: message != null && message.state != PathNavMessageState.reroute
                              ? uikit.ManeuverMessageModel(
                                  comment: message.state.toMessage(context.l10n),
                                  state: message.state.toUIKit(),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: uikit.Spacing.$3x),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: isControlsActive ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: IgnorePointer(
                      ignoring: !isControlsActive,
                      child: GestureDetector(
                        onTap: () {
                          timer?.cancel();
                          timer = null;
                          wasSetActive = true;
                          isControlsActive = true;
                          startControlsDisapearTimer();
                        },
                        child: const Padding(
                          padding: padding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TrafficParkingControl(),
                              SizedBox(height: uikit.Spacing.$2x),
                              DimensionContrtol(),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IndoorControl(),
                                  ZoomControl(),
                                ],
                              ),
                              Spacer(),
                              CompassControl(),
                              SizedBox(height: uikit.Spacing.$2x),
                              FollowControl(),
                              SizedBox(height: uikit.Spacing.$3x),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: systemDirectionality,
                  child: Center(
                    child: RoadPanel(
                      isLoading: isLoading,
                      onSearch: () => context.router.push(NaviSearchRoute()),
                      onEndTrip: () => ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context),
                      onOpenSheet: () => context.router.push(const RoadPanelSheetRoute()),
                    ),
                  ),
                ),
                const SizedBox(height: uikit.Spacing.$5x + uikit.Spacing.px),
              ],
            ),
            const ParkingBottomSheetPage(),
          ],
        ),
      ),
    );
  }
}
