import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/path_nav/ui/eta_continue.dart';
import 'package:mapness/widgets/path_nav/ui/eta_finished.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/landscape/navi_panel_landscape.dart';
import 'package:mapness/widgets/path_nav/ui/map_controls/path_nav_map_controls.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_banner.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_sheet.dart';
import 'package:urbi_analytics/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum PathNavPageInitAction { startNavigation, restoreFromState }

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
@RoutePage()
class PathNavPage extends ConsumerStatefulWidget {
  final RouteSearchOptionsMessage navType;
  final PathNavPageInitAction? initAction;
  final bool isHomeOrWork;

  const PathNavPage({
    required this.navType,
    required this.initAction,
    this.isHomeOrWork = false,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> with WidgetsBindingObserver {
  final bool _navigatorAlreadyStopped = false;

  static const padding = EdgeInsets.symmetric(horizontal: 12);

  late StreamSubscription? _naviEventsListener;
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  double heightOfEta = 90.0;
  final _expansionNotifier = ValueNotifier<bool>(false);
  Size _size = const Size(0, 0);

  final isControlsActive = ValueNotifier(true);
  bool wasSetActive = true;

  Timer? timer;

  late final ValueNotifier<double> _bottomHeightNotifier = ValueNotifier(uikit.Spacing.$3x);

  final uikit.AnimationInfo _animationInfo = uikit.AnimationInfo();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _checkBackgroundNavigationSound(state);
    if (state == AppLifecycleState.paused) {
      saveNavigationState();
    } else if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();
    }
  }

  Future<void> _checkBackgroundNavigationSound(AppLifecycleState state) async {
    final isBackgroundNavigationOn = ref.read(soundSettingsProvider).backgroundNavigation;
    final soundSettingsNotifier = ref.read(soundSettingsProvider.notifier);
    final carConnected = await ref.read(carConnectionProvider.future);
    final muteBackgroundNavigationSound = !carConnected && !isBackgroundNavigationOn;
    if (!muteBackgroundNavigationSound) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      unawaited(soundSettingsNotifier.muteNavigationSound());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(soundSettingsNotifier.restoreNavigationSound());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
      ..addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      })
      ..addObserver(this);

    _initNavigation();
    startControlsDisapearTimer();
    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    final appRouter = ref.read(appRouterProvider);
    // Reset camera position to the center of the screen if the user navigates to another screen only
    if (!appRouter.isRouteActive(PathNavRoute.name)) {
      ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    }
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    final x = MediaQuery.of(context).orientation == Orientation.landscape ? 0.6 : 0.5;
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: x, y: 0.85));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.removeObserver(this);
    _naviEventsListener?.cancel();
    _bottomHeightNotifier.dispose();
    _betterRouteDurationProfit.dispose();
    _navigationState.dispose();
    _expansionNotifier.dispose();
    timer?.cancel();
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
      await _moveCameraToUser();
      await saveNavigationState();
    }
  }

  void startControlsDisapearTimer() {
    timer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        isControlsActive.value = false;
        wasSetActive = false;
      }
    });
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
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    // We use the Directionality widget to set the text direction to ltr.
    // This is necessary for LayersControl to be at the right side of the screen.
    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            PathNavMapControls(
              bottomHeightNotifier: _bottomHeightNotifier,
              navigationState: _navigationState,
              expansionNotifier: _expansionNotifier,
              navType: widget.navType,
              showControls: isControlsActive,
              onRoutePressed: _onShowRoutePressed,
              onUserActivity: () {
                timer?.cancel();
                timer = null;
                wasSetActive = true;
                isControlsActive.value = true;
                startControlsDisapearTimer();
              },
            ),
            if (isPortrait)
              Consumer(
                builder: (_, ref, __) {
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
                },
              ),
            if (isPortrait)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: MeasureSize(
                  onChange: (size) {
                    if (!(ref.read(pathNavEtaProvider)?.isExpanded ?? false) && !_animationInfo.isAnimating) {
                      _size = size;
                      _bottomHeightNotifier.value = size.height + uikit.Spacing.$3x;
                    }
                  },
                  child: Column(
                    children: [
                      ParkingBanner(
                        navigatorType: widget.navType,
                        navigationState: _navigationState,
                        isHomeOrWork: widget.isHomeOrWork,
                      ),
                      Directionality(
                        textDirection: ref.watch(uiDirectionProvider),
                        child: ValueListenableBuilder(
                          valueListenable: _navigationState,
                          builder: (context, state, child) {
                            switch (state) {
                              case PathNavState.running:
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: EtaSheet(
                                    animationInfo: _animationInfo,
                                    onEndTripPressed: () => _endTripAndShowFeedback(context),
                                    onSearchPressed: () => _onSearchPressed(context),
                                    onBetterRouteAccept: () => _acceptBetterRoute(context),
                                    onBetterRouteReject: () => _rejectBetterRoute(context),
                                    betterRouteDurationProfit: _betterRouteDurationProfit,
                                    onTapRoute: _onShowRoutePressed,
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
                                  onSearchPressed: () => _onSearchPressed(context),
                                  expansionNotifier: _expansionNotifier,
                                  onEndTripPressed: () => _endTripAndShowFeedback(context),
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
              )
            else
              Positioned.fill(
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: NaviPanelLandscape(
                    navigationState: _navigationState,
                    expansionNotifier: _expansionNotifier,
                    onShowRoutePressed: _onShowRoutePressed,
                    acceptBetterRoute: _acceptBetterRoute,
                    rejectBetterRoute: _rejectBetterRoute,
                    betterRouteDurationProfit: _betterRouteDurationProfit,
                    onSizeChanged: _onSizeChanged,
                    onContinuePressed: _onContinuePressed,
                    endTripAndShowHome: _endTripAndShowHome,
                    endTripAndBuildAnotherRoute: _endTripAndBuildAnotherRoute,
                    onSearchPressed: _onSearchPressed,
                    onTapRoute: _onShowRoutePressed,
                  ),
                ),
              ),
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                timer?.cancel();
                timer = null;
                setState(() {
                  if (!isControlsActive.value) {
                    wasSetActive = true;
                    isControlsActive.value = true;
                  }
                });
              },
              onPointerUp: (event) {
                startControlsDisapearTimer();
              },
            ),
            ParkingBottomSheetPage(onSizeChanged: _onSizeChangedParking),
          ],
        ),
      ),
    );
  }

  // Different actions for different states. We have to stop navigation and remove all markers when the trip is finished
  // Also we do action (in our case we navigate to the home page or to route page) after the trip is finished
  Future<void> _endTrip({VoidCallback? action}) async {
    final route = ref.read(etaRouteInfoProvider);
    final pathInfo = ref.read(pathNavEtaProvider);
    ref.read(appAnalyticsProvider).navigationCompleted(
          origin: route.startPoint?.analyticsLabel ?? '',
          destination: route.endPoint?.analyticsLabel ?? '',
          spentTime: pathInfo?.spentTime ?? Duration.zero,
        );
    await _stopActiveSharing();
    await ref.read(cameraPaddingProvider.notifier).resetPadding();

    if (_navigationState.value != PathNavState.finished) {
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.navigationRoutingHalfway);
      ref.read(advertMetricsProvider.notifier).sendEvent(
            AdvertMetricsKeys.journeyHalfwayUnique,
            isUniquePerSession: true,
          );
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
    }

    await clearNavigationState();
    await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
    ref.read(layersControlsProvider.notifier).updateLayerInfo();

    final mapSettings = MapObjectManagerSettings.search();
    final mapObjectProvider = ref.read(mapObjectManagerProvider(
      named: mapSettings.name,
      layerId: mapSettings.layerId,
    ).notifier);

    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: true);

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    if (isLandscape) {
      await context.router.push(const FlipsContinueRoute());
      action?.call();
      return;
    }

    action?.call();
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

    await _parkingCheck();

    await _endTrip();

    if (!ctx.mounted) {
      return;
    }

    // We don't show the feedback page in landscape mode
    if (MediaQuery.of(context).orientation != Orientation.landscape) {
      await ctx.router.push(AppFeedbackSheet(source: FeedbackSource.navi));
    }

    if (!ctx.mounted) {
      return;
    }

    context.router.popUntilRouteWithName(BottomMenuRoute.name);

    final parkingManage = ref.read(parkingManageProvider).valueOrNull == null;
    final position = ref.read(locationProvider);

    ToastOverlay.of(context).show(
      title: ctx.l10n.youWantSaveParking,
      firstText: ctx.l10n.feedbackBreaksSheetClose,
      secondText: ctx.l10n.save,
      iconAsset: Assets.icons.svg.icParkingSpot.keyName,
      onSecondTap: () {
        rootNavigatorKey.currentContext?.router.push(
          ParkingSpotRoute(
            isEdit: !parkingManage,
            markerPosition: GeoPointWithElevationMessage(
              latitude: position?.latitude ?? 0,
              longitude: position?.longitude ?? 0,
              elevation: 1,
            ),
          ),
        );
      },
    );
  }

  /// If I enable parking during [FreeRoam], after the check is completed they are hidden if hidden from [Layers].
  /// If it is enabled in [Layers], then if I disable it in [FreeRoam], then after completion they are also disabled
  Future<void> _parkingCheck() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isParkingEnabledByFreeRoam = sharedPrefs.getBool(MapnessConstants.parkingEnabledFreeRoam) ?? false;

    if (isParkingEnabledByFreeRoam) {
      final layersControls = ref.read(layersControlsProvider.notifier);
      if (ref.read(activeLayerProvider) == LayerType.parkingLots) {
        await layersControls.hideActiveLayer();
      }
      await sharedPrefs.setBool(MapnessConstants.parkingEnabledFreeRoam, false);
    }
  }

  // Show the pause state
  Future<void> _onShowRoutePressed() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.showRoute,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);
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
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.navigationRoutingCompleted);
      ref.read(advertMetricsProvider.notifier).sendEvent(
            AdvertMetricsKeys.journeyCompleteUnique,
            isUniquePerSession: true,
          );
      _navigationState.value = PathNavState.finished;
      ref.read(layersControlsProvider.notifier).hideParking();
      ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);

      unawaited(clearNavigationState());
      unawaited(_stopActiveSharing());
    } else if (event == NavigationEvent.disabled) {
      if (context.mounted && _navigationState.value != PathNavState.finished) {
        _endTripAndShowHome();
      }
    }
  }

  Future<void> _moveCameraToUser() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final position = ref.read(locationProvider);
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    await dgisController.startFollowNavigation();
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
    switch (MediaQuery.of(context).orientation) {
      case Orientation.portrait:
        {
          final pixelSize = MediaQuery.of(context).devicePixelRatio;
          ref.read(cameraPaddingProvider.notifier).setPadding(
                CameraSetPaddingMessage(
                  bottomPadding: (pixelSize * padding).floor(),
                ),
              );
        }
      case Orientation.landscape:
        ref.read(cameraPaddingProvider.notifier).setPadding(CameraSetPaddingMessage());
    }
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
      await ref.read(shareEtaProvider.notifier).stopSharingAndClearCurrent();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onSearchPressed(BuildContext context) async {
    final mapSettings = MapObjectManagerSettings.search();
    final mapObjectProvider = ref.read(mapObjectManagerProvider(
      named: mapSettings.name,
      layerId: mapSettings.layerId,
    ).notifier);

    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: true);
    await context.router.push(NaviSearchRoute(isPathNavScreen: true));
    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: false);
  }

  void _onSizeChangedParking(double size) {
    // TODO(Ayat) fix sheetHeight in BottomSheet, is not correct calculate
    final height = size + uikit.Spacing.$10x;
    _bottomHeightNotifier.value = max(height, uikit.Spacing.$3x + _size.height);
  }
}
