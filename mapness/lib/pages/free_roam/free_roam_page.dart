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

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
class FreeRoamPage extends ConsumerStatefulWidget {
  // final bool restoreFromState;

  const FreeRoamPage({
    // required this.restoreFromState,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FreeRoamPageState();
}

class FreeRoamPageState extends ConsumerState<FreeRoamPage> with WidgetsBindingObserver {
  static const padding = EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x);

  bool isLoading = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // saveNavigationState();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFreeRoam().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    WakelockPlus.disable();
    super.dispose();
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

    await dgisController.stopNavigation();
    await dgisController.freeRoamController.start();
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
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

                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Material(
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
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: padding,
                    child: TrafficParkingControl(),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IndoorControl(),
                        ZoomControl(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: padding,
                    child: CompassControl(),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: padding,
                    child: FollowControl(),
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
        ),
      );

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip(VoidCallback action) async {
    if (!mounted) {
      return;
    }

    await ref.read(dgisControllerProvider).value?.freeRoamController.stop();

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
    await ref.read(urbiAnalyticsProvider).track('tripStopped');

    await _endTrip(() {
      if (context.mounted) {
        const LandingRoute().go(context);
      }
    });
  }
}
