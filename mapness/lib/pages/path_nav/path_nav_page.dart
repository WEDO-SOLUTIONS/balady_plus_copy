// ignore_for_file: prefer_expression_function_bodies

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
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/pages/path_nav/ui/eta_continue.dart';
import 'package:mapness/pages/path_nav/ui/eta_finished.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
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
  final RouteSearchOptionsMessage navType;

  const PathNavPage({
    required this.navType,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> {
  static const padding = EdgeInsets.symmetric(horizontal: 12);

  late StreamSubscription? _naviEventsListener;
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  double heightOfEta = 90.0;
  final _expansionNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _initNavigation();

    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));

    super.deactivate();
  }

  @override
  void dispose() {
    _naviEventsListener?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _initNavigation() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    await dgisController.setNavigatorVoice(
      ref.read(navigatorVoiceProvider),
    );
    _naviEventsListener = dgisController.navigationEvents.listen(_naviEvent);
    await dgisController.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
    await dgisController.startNavigation();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      betterRouteProvider,
      (_, next) => next == null
          ? _betterRouteDurationProfit.value = null
          : _betterRouteDurationProfit.value = next.durationProfit,
    );

    // We use the Directionality widget to set the text direction to ltr.
    // This is necessary for LayersControl to be at the right side of the screen.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Expanded(child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final value = _expansionNotifier.value;
                if (value) {
                  _expansionNotifier.value = !value;
                }
              },
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 6, width: double.maxFinite),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.verticalBaseToTopSafezone),
                  child: Directionality(
                    // Here we set the text direction according to the current locale to display the correct direction of the widget.
                    textDirection: Directionality.of(context),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final message = ref.watch(pathNavMessageProvider);
                        final maneuver = ref.watch(pathNavManeuverProvider);
                        final isPedestrian = widget.navType == RouteSearchOptionsMessage.pedestrian;
                        final info = ref.watch(pathNavSpeedInfoProvider);

                        // This made to remove yellow lines under the text
                        return Material(
                          type: MaterialType.transparency,
                          color: Colors.transparent,
                          child: uikit.BaladyManeuverAndLimit(
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
                                    comment: message.state.toMessage(context.l10n),
                                    state: message.state.toUIKit(),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                  // Here we set the text direction according to the current locale to display the correct direction of the widget.
                  textDirection: Directionality.of(context),
                  child: ValueListenableBuilder(
                      valueListenable: _navigationState,
                      builder: (context, state, child) {
                        switch (state) {
                          case PathNavState.running:
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: EtaSheet(
                                onEndTripPressed: _endTripAndShowHome,
                                onRoutePressed: _onShowRoutePressed,
                                onBetterRouteAccept: () => _acceptBetterRoute(context),
                                onBetterRouteReject: () => _rejectBetterRoute(context),
                                betterRouteDurationProfit: _betterRouteDurationProfit,
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
                              expansionNotifier: _expansionNotifier,
                              onEndTripPressed: _endTripAndShowHome,
                              onBuildAnotherRoutePressed: _endTripAndBuildAnotherRoute,
                              onSizeChanged: _onSizeChanged,
                            );
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip(VoidCallback action) async {
    if (_navigationState.value != PathNavState.finished) {
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
      _navigationState.value = PathNavState.finished;
    }
    action();
    await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
    ref.read(layersControlsProvider.notifier).updateLayerInfo();
  }

  // Show the route page after the trip is finished
  Future<void> _endTripAndBuildAnotherRoute() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndBuildAnother,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await _endTrip(() {
      if (context.mounted) {
        const RoutingRoute(collapseInitially: true).go(context);
      }
    });
  }

  // Show the home page after the trip is finished
  Future<void> _endTripAndShowHome() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await _endTrip(() {
      if (context.mounted) {
        const LandingRoute().go(context);
      }
    });
  }

  // Show the pause state
  Future<void> _onShowRoutePressed() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.showRoute,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    _betterRouteDurationProfit.value = null;
    _navigationState.value = PathNavState.paused;
    await ref.read(cameraPositionProvider.notifier).animateToRoute();
  }

  // Continue the trip after the pause state
  Future<void> _onContinuePressed() async {
    _navigationState.value = PathNavState.running;
    final dgisController = await ref.read(dgisControllerProvider.future);
    await _moveCameraToUser();
    await dgisController.followNavigation();
  }

  // Notify the listeners about the end of the trip
  void _naviEvent(NavigationEvent event) {
    if (event == NavigationEvent.finished) {
      _navigationState.value = PathNavState.finished;
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

  // Set padding to the camera to avoid the sheet overlaying the map
  // Pass this method to the onSizeChanged callback of the sheet to calculate the padding
  void _onSizeChanged(Size size) {
    setState(() {
      heightOfEta = size.height;
    });

    _setPaddingToCamera(heightOfEta);
  }

  // Set padding to the camera to avoid the sheet overlaying the map
  void _setPaddingToCamera(double padding) {
    final pixelSize = MediaQuery.of(context).devicePixelRatio;
    ref.read(cameraPaddingProvider.notifier).setPadding(
          CameraSetPaddingMessage(
            leftPadding: 0,
            topPadding: 0,
            rightPadding: 0,
            bottomPadding: (pixelSize * padding).floor(),
          ),
        );
  }

  Future<void> _acceptBetterRoute(BuildContext context) async {
    _betterRouteDurationProfit.value = null;
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.betterRouteResponse(BetterRouteResponseMessage.accept);
  }

  Future<void> _rejectBetterRoute(BuildContext context) async {
    _betterRouteDurationProfit.value = null;
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.betterRouteResponse(BetterRouteResponseMessage.reject);
  }
}
