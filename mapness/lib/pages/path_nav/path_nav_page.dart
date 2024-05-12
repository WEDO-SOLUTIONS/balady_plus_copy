import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/pages/path_nav/ui/eta_continue.dart';
import 'package:mapness/pages/path_nav/ui/eta_finished.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_follow_control.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
class PathNavPage extends ConsumerStatefulWidget {
  const PathNavPage({
    required this.navType,
    super.key,
  });
  final RouteSearchOptionsMessage navType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> {
  ValueNotifier<PathNavState> navigationState =
      ValueNotifier(PathNavState.running);
  double heightOfEta = 90.0;

  late StreamSubscription? _naviEventsListener;

  void _setNavigationState(PathNavState value) {
    setState(() {
      navigationState.value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(dgisControllerProvider).value?.setNavigatorVoice(
          ref.read(navigatorVoiceProvider),
        );
    _naviEventsListener = ref
        .read(dgisControllerProvider)
        .value
        ?.navigationEvents
        .listen(_naviEvent);
    unawaited(ref.read(dgisControllerProvider).value?.startNavigation());
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _setPaddingToCamera(0.0);
    _naviEventsListener?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _endTrip(VoidCallback action) async {
    if (navigationState.value != PathNavState.finished) {
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
      _setNavigationState(PathNavState.finished);
    }
    _setPaddingToCamera(0.0);
    action();
    await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
    ref.read(layersControlsProvider.notifier).updateLayerInfo();
  }

  Future<void> _endTripAndBuildAnotherRoute() async {
    await _endTrip(() {
      if (context.mounted) {
        const RoutingRoute(collapseInitially: true).go(context);
      }
    });
  }

  Future<void> _endTripAndShowHome() async {
    await _endTrip(() {
      if (context.mounted) {
        const LandingRoute().go(context);
      }
    });
  }

  Future<void> _onPausedPressed() async {
    _setNavigationState(PathNavState.paused);
    await ref.read(cameraPositionProvider.notifier).animateToRoute();
  }

  Future<void> _onContinuePressed() async {
    _setNavigationState(PathNavState.running);
    final dgisController = await ref.read(dgisControllerProvider.future);

    await _moveCameraToUser();

    await dgisController.followNavigation();
  }

  void _naviEvent(NavigationEvent event) {
    if (event == NavigationEvent.finished) {
      _setNavigationState(PathNavState.finished);
    }
  }

  Future<void> _moveCameraToUser() async {
    final position = ref.read(locationProvider);
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    if (position != null) {
      await cameraProvider.animateTo(
        CameraPositionMessage(
          point: position,
          zoom: 17.5,
          tilt: 0,
          bearing: 0,
        ),
      );
    }
  }

  void _onSizeChanged(Size size) {
    setState(() {
      heightOfEta = size.height;
    });

    _setPaddingToCamera(heightOfEta);
  }

  void _setPaddingToCamera(double padding) {
    final pixelSize = MediaQuery.of(context).devicePixelRatio;
    ref.watch(cameraPositionProvider.notifier).setPadding(
          CameraSetPaddingMessage(
            leftPadding: 0,
            topPadding: 0,
            rightPadding: 0,
            bottomPadding: (pixelSize * padding).floor(),
          ),
        );
  }

  static const padding = EdgeInsets.symmetric(horizontal: 12);

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 6,
                width: double.maxFinite,
              ),
              Directionality(
                textDirection: Directionality.of(context),
                child: Consumer(
                  builder: (context, ref, child) {
                    final message = ref.watch(pathNavMessageProvider);
                    final maneuver = ref.watch(pathNavManeuverProvider);
                    final isPedestrian =
                        widget.navType == RouteSearchOptionsMessage.pedestrian;
                    final info = ref.watch(pathNavSpeedInfoProvider);
                    return uikit.BaladyManeuverAndLimit(
                      isPedestrian: isPedestrian,
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
                      message: message != null
                          ? uikit.ManeuverMessageModel(
                              comment: message.comment,
                              state: message.state.toUIKit(),
                            )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: padding,
                child: Consumer(
                  builder: (context, ref, _) {
                    final navi = ref.watch(appFeaturesProvider);
                    return Visibility(
                      visible: navi.naviEnabled,
                      replacement: const SizedBox.square(
                        dimension: 28,
                      ),
                      child: const TrafficControl(),
                    );
                  },
                ),
              ),
              const Spacer(),
              const Padding(
                padding: padding,
                child: ZoomControl(),
              ),
              const Spacer(),
              const Padding(
                padding: padding,
                child: CompassControl(),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: padding,
                child: PathNavFollowControl(),
              ),
              const SizedBox(height: 12),
              Directionality(
                textDirection: Directionality.of(context),
                child: ValueListenableBuilder(
                    valueListenable: navigationState,
                    builder: (context, state, child) {
                      switch (state) {
                        case PathNavState.running:
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: EtaSheet(
                              onEndTripPressed: _endTripAndShowHome,
                              onRoutePressed: _onPausedPressed,
                              onSizeChanged: _onSizeChanged,
                            ),
                          );
                        case PathNavState.paused:
                          return EtaContinue(
                            onTap: _onContinuePressed,
                            onSizeChanged: _onSizeChanged,
                          );
                        case PathNavState.finished:
                          return EtaFinished(
                            onEndTripPressed: _endTripAndShowHome,
                            onBuildAnotherRoutePressed:
                                _endTripAndBuildAnotherRoute,
                            onSizeChanged: _onSizeChanged,
                          );
                      }
                    }),
              ),
            ],
          ),
        ),
      );
}
