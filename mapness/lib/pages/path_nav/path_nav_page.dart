import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/notifier_size/size_reporter.dart';
import 'package:mapness/shared/ui/notifier_size/size_widget_notifier.dart';
import 'package:mapness/widgets/path_nav/ui/eta_continue.dart';
import 'package:mapness/widgets/path_nav/ui/eta_finished.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/parking_banner.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_map_controls.dart';
import 'package:urbi_analytics/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
class PathNavPage extends ConsumerStatefulWidget {
  final RouteSearchOptionsMessage navType;
  final bool restoreFromState;

  const PathNavPage({
    required this.navType,
    required this.restoreFromState,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> with WidgetsBindingObserver {
  late StreamSubscription? _naviEventsListener;
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  double heightOfEta = 90.0;
  final _expansionNotifier = ValueNotifier<bool>(false);

  late final ValueNotifier<double> _bottomHeightNotifier = ValueNotifier(uikit.Spacing.$3x);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isBackgroundNavigationOn = ref.watch(soundSettingsProvider).backgroundNavigation;
    final soundSettingsNotifier = ref.watch(soundSettingsProvider.notifier);

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
    _bottomHeightNotifier.dispose();
    _betterRouteDurationProfit.dispose();
    _navigationState.dispose();
    _expansionNotifier.dispose();
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
      context.pop();
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
    if (widget.restoreFromState) {
      await restoreNavigationState();
    } else {
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
    final isEtaExpanded = ref.watch(pathNavEtaProvider)?.isExpanded ?? false;

    // We use the Directionality widget to set the text direction to ltr.
    // This is necessary for LayersControl to be at the right side of the screen.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          PathNavMapControls(
            bottomHeightNotifier: _bottomHeightNotifier,
            navigationState: _navigationState,
            expansionNotifier: _expansionNotifier,
            navType: widget.navType,
          ),
          if (isEtaExpanded)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);
              },
              child: SizedBox.expand(
                child: ColoredBox(
                  color: AppColor.black.withOpacity(0.4),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: NotificationListener<SizeWidgetNotification>(
              onNotification: (notifierSize) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!isEtaExpanded) {
                    _bottomHeightNotifier.value = notifierSize.size.height + uikit.Spacing.$3x;
                  }
                });

                return true;
              },
              child: SizeReporter(
                child: Column(
                  children: [
                    ParkingBanner(navigationState: _navigationState),
                    Directionality(
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip(VoidCallback action) async {
    try {
      await _stopActiveSharing();
    } catch (e) {
      log(e.toString());
    }

    if (_navigationState.value != PathNavState.finished) {
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
    }

    await clearNavigationState();
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
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

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
    switch (event) {
      case NavigationEvent.finished:
        ref.read(urbiAnalyticsProvider).track('tripCompleted');
        _navigationState.value = PathNavState.finished;
        unawaited(
          clearNavigationState(),
        );
      case NavigationEvent.disabled:
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

  Future<void> _stopActiveSharing() async {
    final tokenId = EtaStreamStorage().state.streamToken;
    final xStreamData = EtaStreamStorage().state.xStreamData;
    if (tokenId != null && xStreamData != null) {
      await ref.read(shareEtaProvider.notifier).stopSharing(tokenId, xStreamData);
    }
  }
}
