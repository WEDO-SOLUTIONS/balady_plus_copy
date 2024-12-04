import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/pages/path_nav/lib/utils.dart';
import 'package:mapness/pages/path_nav/ui/eta_continue.dart';
import 'package:mapness/pages/path_nav/ui/eta_finished.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_follow_control.dart';
import 'package:urbi_analytics/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum PathNavPageInitAction { startNavigation, restoreFromState }

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
@RoutePage()
class PathNavPage extends ConsumerStatefulWidget {
  final RouteSearchOptionsMessage navType;
  final PathNavPageInitAction? initAction;

  const PathNavPage({
    required this.navType,
    required this.initAction,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> with WidgetsBindingObserver {
  bool _navigatorAlreadyStopped = false;

  static const padding = EdgeInsets.symmetric(horizontal: 12);

  late StreamSubscription? _naviEventsListener;
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  double heightOfEta = 90.0;
  final _expansionNotifier = ValueNotifier<bool>(false);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isBackgroundNavigationOn = ref.read(soundSettingsProvider).backgroundNavigation;
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);

    if (state == AppLifecycleState.paused) {
      saveNavigationState();

      if (!isBackgroundNavigationOn) {
        soundSettingsNotifier.muteNavigationSound();
      }
    } else if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();

      if (!isBackgroundNavigationOn) {
        soundSettingsNotifier.restoreNavigationSound();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _naviEventsListener?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> saveNavigationState() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    final state = await dgisController.saveNavigationState();
    await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateKey, base64.encode(state));
    await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateTypeKey, widget.navType.name);
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
      await clearNavigationState();
      context.router.popForced();
    }
  }

  Future<void> clearNavigationState() async {
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateKey);
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateTypeKey);
  }

  Future<void> _initNavigation() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    _naviEventsListener = dgisController.navigationEvents.listen(_naviEvent);
    await dgisController.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
    if (widget.initAction == PathNavPageInitAction.restoreFromState) {
      await restoreNavigationState();
    } else if (widget.initAction == PathNavPageInitAction.startNavigation) {
      await dgisController.startNavigation(
        SpeedRangeZoom(
          maxSpeedRange: 5,
          minSpeedRange: 0,
          routeDistanceMillimeters: 0,
          styleZoomValue: 16.5,
        ),
      );
      await saveNavigationState();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(
        betterRouteProvider,
        (_, next) => next == null
            ? _betterRouteDurationProfit.value = null
            : _betterRouteDurationProfit.value = next.durationProfit,
      )
      ..listen(carConnectionProvider, (_, next) {
        final connected = next.valueOrNull ?? false;
        final shouldEndTrip = connected &&
            widget.navType != RouteSearchOptionsMessage.car &&
            _navigationState.value != PathNavState.finished;
        if (shouldEndTrip) {
          _endTripAndShowHome();
        }
      });

    // We use the Directionality widget to set the text direction to ltr.
    // This is necessary for LayersControl to be at the right side of the screen.
    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _navigationState,
                    builder: (context, state, child) {
                      if (state == PathNavState.finished) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            final value = _expansionNotifier.value;
                            if (value) {
                              _expansionNotifier.value = !value;
                            }
                          },
                          child: const SizedBox.expand(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 6, width: double.maxFinite),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
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
                      const Spacer(),
                      Padding(
                        padding: padding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.navType == RouteSearchOptionsMessage.pedestrian)
                              const IndoorControl()
                            else
                              const SizedBox.shrink(),
                            const ZoomControl(),
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
                        child: PathNavFollowControl(),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Consumer(builder: (context, ref, _) {
              final isEtaExpanded = ref.watch(pathNavEtaProvider)?.isExpanded ?? false;
              return isEtaExpanded
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);
                      },
                      child: SizedBox.expand(
                        child: ColoredBox(
                          color: AppColor.black.withOpacity(0.4),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Directionality(
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
                            onEndTripPressed: () => _endTripAndShowFeedback(context),
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip({VoidCallback? action}) async {
    _navigatorAlreadyStopped = true;
    await _stopActiveSharing();

    if (_navigationState.value != PathNavState.finished) {
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
    }

    await clearNavigationState();
    action?.call();

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

    await _endTrip(action: () {
      if (context.mounted) {
        context.router.navigate(const RoutingPointsRoute());
      }
    });
  }

  // Show the home page after the trip is finished
  Future<void> _endTripAndShowHome() async {
    if (_navigatorAlreadyStopped) {
      return;
    }
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip(action: () {
      if (context.mounted) {
        context.router.popUntilRouteWithName(BottomMenuRoute.name);
      }
    });
  }

  // Show the feedback page after the trip is finished manually
  Future<void> _endTripAndShowFeedback(BuildContext ctx) async {
    /// Because we call stop navigation in other places and with other events
    /// we need to check if the navigation is already stopped
    if (_navigatorAlreadyStopped) {
      return;
    }
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip();

    if (!ctx.mounted) {
      return;
    }

    await ctx.router.push(AppFeedbackSheet(source: FeedbackSource.navi));

    if (!ctx.mounted) {
      return;
    }
    context.router.popUntilRouteWithName(BottomMenuRoute.name);
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
      ref.read(urbiAnalyticsProvider).track('tripCompleted');
      _navigationState.value = PathNavState.finished;
      unawaited(clearNavigationState());
      unawaited(_stopActiveSharing());
    } else if (event == NavigationEvent.disabled) {
      if (_navigationState.value != PathNavState.finished) {
        _endTripAndShowHome();
      }
    }
  }

  Future<void> _moveCameraToUser() async {
    final position = ref.read(locationProvider);
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    if (position != null) {
      await cameraProvider.animateTo(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: position.latitude, longitude: position.longitude),
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
    heightOfEta = size.height;

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

  Future<void> _stopActiveSharing() async {
    try {
      await ref.read(shareEtaProvider.notifier).stopSharingCurrent();
    } catch (e) {
      log(e.toString());
    }
  }
}
