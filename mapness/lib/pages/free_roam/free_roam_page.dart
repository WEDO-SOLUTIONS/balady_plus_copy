import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/road_panel.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/free_roam/ui/road_panel.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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

  @override
  void initState() {
    super.initState();

    _initFreeRoam().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    startControlsDisapearTimer();

    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    super.deactivate();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void startControlsDisapearTimer() {
    timer = Timer(const Duration(seconds: 15), () {
      setState(() {
        isControlsActive = false;
        wasSetActive = false;
      });
    });
  }

  Future<void> restoreNavigationState() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    final state = base64.decode(
      ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateKey)!,
    );
    try {
      await dgisController.restoreNavigationState(
        state,
        SpeedRangeZoom(
          maxSpeedRange: 5,
          minSpeedRange: 0,
          routeDistanceMillimeters: 0,
          styleZoomValue: 16.5,
        ),
      );
    } catch (e) {
      context.pop();
    }
  }

  Future<void> _initFreeRoam() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    await dgisController.setNavigatorVoice(ref.read(navigatorVoiceProvider));

    await dgisController.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
    await dgisController.followNavigation();

    await dgisController.freeRoamController.start();
    await dgisController.setMapAttributeBool('navigatorOn', value: true);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
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
              behavior: HitTestBehavior.translucent,
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
                const SizedBox(height: 6, width: double.maxFinite),
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
                const SizedBox(height: 12),
                Padding(
                  padding: padding,
                  child: AnimatedOpacity(
                      opacity: isControlsActive ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const TrafficParkingControl()),
                ),
                const Spacer(),
                Padding(
                  padding: padding,
                  child: AnimatedOpacity(
                    opacity: isControlsActive ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IndoorControl(),
                        ZoomControl(),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: padding,
                  child: AnimatedOpacity(
                      opacity: isControlsActive ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: const CompassControl()),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: padding,
                  child: AnimatedOpacity(
                    opacity: isControlsActive ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const FollowControl(),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RoadPanel(
                    isLoading: isLoading,
                    onEndTrip: _endTripAndShowHome,
                    onOpenSheet: () => RoadPanelRoute.open(context),
                  ),
                ),
                const SizedBox(height: 21),
              ],
            ),
          ],
        ),
      );

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip(VoidCallback action) async {
    if (!mounted) {
      return;
    }
    final dgisController = ref.read(dgisControllerProvider);
    await dgisController.value?.freeRoamController.stop();
    await dgisController.value?.setMapAttributeBool('navigatorOn', value: false);

    action();
  }

  // Show the home page after the trip is finished
  Future<void> _endTripAndShowHome() async {
    if (!mounted) {
      return;
    }

    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip(() {
      if (context.mounted) {
        const LandingRoute().go(context);
      }
    });
  }
}
