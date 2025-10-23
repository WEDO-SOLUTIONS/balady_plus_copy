import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/features/path_nav/providers/active_public_transport_route.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/pages/path_nav/path_nav_wrapper.dart';
import 'package:mapness/pages/routing/route_details_sheet.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/parking_autoenabled_sheet_provider.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/path_nav/ui/map_controls/path_nav_map_controls.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_sheet.dart';
import 'package:sheetify/sheetify.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum PathNavPageInitAction { startNavigation, restoreFromState }

/// We don't show black background under the opened sheet. The meaning of this is that the user have to control the map even if he opened the sheet.
/// You don't need to add black background to make the app similar to the other app
@RoutePage()
class PathNavPage extends StatefulHookConsumerWidget {
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
  final panelKey = GlobalKey();
  static const padding = EdgeInsets.symmetric(horizontal: 12);

  late final ValueNotifier<double> _bottomHeightNotifier = ValueNotifier(uikit.Spacing.$3x);
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  final isControlsActive = ValueNotifier(true);

  late StreamSubscription? _naviEventsListener;
  bool wasSetActive = true;
  Timer? timer;

  late ToggleSheetController sheetController;

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
        await _metroOnInit();
      })
      ..addObserver(this);

    _initNavigation();
    startControlsDisapearTimer();
    ref.read(layersControlsProvider.notifier).hideLayer(LayerType.metro);
    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    final appRouter = ref.read(appRouterProvider);
    // Reset camera position to the center of the screen if the user navigates to another screen only
    if (!appRouter.isRouteActive(PathNavRoute.name)) {
      ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    }

    // Restore the active layer if we go back from the routing info screen
    ref.read(layersControlsProvider.notifier).restorePreviousLayer();
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
        NavigationConstants.navigationSpeedRangeZooms,
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
        NavigationConstants.navigationSpeedRangeZooms,
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
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    sheetController = useToggleSheetController(
      onClose: (_) {},
      clipByHeader: true,
      resetContentScrollOnClosed: true,
    )..updateHeightModel(
        isPortrait ? null : ToggleSheetHeightModel.offset(uikit.Spacing.$3x),
      );

    void onSheetHeightChanged() {
      if (isPortrait) {
        final padding = MediaQuery.paddingOf(context).bottom;

        final sheetHeight = sheetController.componentSizes.header + uikit.Spacing.$3x + padding + uikit.Spacing.$4x;

        if (_bottomHeightNotifier.value != sheetHeight) {
          _bottomHeightNotifier.value = sheetHeight;
          _setPaddingToCamera(_bottomHeightNotifier.value);
        }
      }
    }

    void navigationStateChanged() {
      final state = _navigationState.value;
      if (state == PathNavState.running) {
        sheetController.isInteractive = true;
      } else if (state == PathNavState.paused || state == PathNavState.finished) {
        sheetController
          ..isInteractive = false
          ..close();
      }
    }

    useEffect(() {
      sheetController.addListener(onSheetHeightChanged);
      final padding = MediaQuery.paddingOf(context).bottom;
      _bottomHeightNotifier.value = sheetController.sheetHeight + uikit.Spacing.$3x + padding + uikit.Spacing.$4x;
      return () => sheetController.removeListener(onSheetHeightChanged);
    }, []);

    useEffect(() {
      _navigationState.addListener(navigationStateChanged);
      return () => _navigationState.removeListener(navigationStateChanged);
    }, []);

    final publicRoute = ref.watch(activePublicTransportRouteProvider);
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
      })
      ..listen(
        pathNavEtaProvider,
        (previous, next) {
          if (next != null) {
            if (next.distanceEtaUnits != DistanceUnits.m) {
              return;
            }
            final distance = double.tryParse(next.distanceEta);
            final navParkingEnabled = ref.read(navigatorAutoEnableParkingProvider);
            final activeLayer = ref.read(activeLayerProvider);
            final distanceLessThen500Meters = distance != null && distance <= 500;
            final parkingTurnedOn = activeLayer == LayerType.parkingLots;
            if (distanceLessThen500Meters && navParkingEnabled == true && !parkingTurnedOn) {
              ref.read(layersControlsProvider.notifier).enableParking();
            }
          }
        },
      );

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
              ListenableBuilder(
                listenable: sheetController,
                builder: (context, _) => !sheetController.isClosed
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
                          sheetController.close();
                        },
                        child: const SizedBox.expand(),
                      )
                    : const SizedBox.shrink(),
              ),
            if (widget.navType == RouteSearchOptionsMessage.publicTransport && publicRoute != null)
              Builder(builder: (context) {
                final startPoint = ref.read(etaRouteInfoProvider).startPoint;
                final destination = ref.read(etaRouteInfoProvider).endPoint;
                if (startPoint == null || destination == null) {
                  return const SizedBox.shrink();
                }
                return RouteDetailsPage(
                  type: RouteDetailsSheetType.driving,
                  startPoint: RouteParamsPointWithLabel(
                    label: startPoint.label ?? '',
                    value: RouteParamsPoint(
                      latitude: startPoint.lat ?? 0,
                      longitude: startPoint.lon ?? 0,
                    ),
                  ),
                  destination: RouteParamsPointWithLabel(
                    label: destination.label ?? '',
                    value: RouteParamsPoint(
                      latitude: destination.lat ?? 0,
                      longitude: destination.lon ?? 0,
                    ),
                  ),
                  publicTransportRoutes: [publicRoute],
                  onPressed: () async {
                    // Remove route from the map for public transport
                    await ref.read(dgisControllerProvider).value?.hideRoutes();
                    await _endTripAndShowFeedback(context);
                  },
                  onClose: () async {
                    await ref.read(dgisControllerProvider).value?.hideRoutes();
                    await _endTripAndShowHome();
                  },
                  buttonLabel: context.l10n.endTrip,
                );
              }),
            if (widget.navType != RouteSearchOptionsMessage.publicTransport)
              PathNavWrapper(
                isPortrait: isPortrait,
                indoorControl: widget.navType == RouteSearchOptionsMessage.pedestrian
                    ? const Padding(
                        padding: padding,
                        child: IndoorControl(),
                      )
                    : null,
                child: NaviSheetPanel(
                  key: panelKey,
                  navType: widget.navType,
                  navigationState: _navigationState,
                  onShowRoutePressed: _onShowRoutePressed,
                  acceptBetterRoute: _acceptBetterRoute,
                  rejectBetterRoute: _rejectBetterRoute,
                  betterRouteDurationProfit: _betterRouteDurationProfit,
                  onContinuePressed: _onContinuePressed,
                  endTripAndShowHome: _endTripAndShowHome,
                  endTripAndBuildAnotherRoute: _endTripAndBuildAnotherRoute,
                  onSearchPressed: _onSearchPressed,
                  onTapRoute: _onShowRoutePressed,
                  onEndTripPressed: () => _endTripAndShowFeedback(context),
                  sheetController: sheetController,
                  isLandscape: !isPortrait,
                  isHomeOrWork: widget.isHomeOrWork,
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
            const ParkingBottomSheetPage(),
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
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final location = ref.read(cityByLocationProvider.notifier);
    final originCity = await location.getCityByLatLng(lat: route.startPoint?.lat, lng: route.startPoint?.lon);
    final destinationCity = await location.getCityByLatLng(lat: route.endPoint?.lat, lng: route.endPoint?.lon);

    ref.read(appAnalyticsProvider).navigationCompleted(
          origin: route.startPoint?.analyticsLabel ?? '',
          destination: route.endPoint?.analyticsLabel ?? '',
          originCity: originCity.name,
          destinationCity: destinationCity.name,
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
      ref.read(currentRouteProvider.notifier).clearRoute();
    }

    // Remove route from the map for public transport
    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      await ref.read(dgisControllerProvider).value?.hideRoutes();
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
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip(action: () {
      if (mounted) {
        context.router.popUntilRouteWithName(BottomMenuRoute.name);
      }
    });
  }

  // Show the feedback page after the trip is finished manually
  Future<void> _endTripAndShowFeedback(BuildContext ctx) async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _parkingCheck();

    await _endTrip();

    if (!mounted) {
      return;
    }

    context.router.popUntilRouteWithName(BottomMenuRoute.name);

    if (!mounted) {
      return;
    }

    final parkingManage = ref.read(parkingManageProvider).valueOrNull == null;
    final position = ref.read(locationProvider);

    ToastOverlay.of(context).show(
      title: ctx.l10n.youWantSaveParking,
      actions: [
        ToastAction(title: ctx.l10n.feedbackBreaksSheetClose),
        ToastAction(
          title: ctx.l10n.save,
          onTap: () {
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
        ),
      ],
      icon: ToastIconAsset(Assets.icons.svg.icParkingSpot.keyName),
    );

    if (!mounted) {
      return;
    }

    // We don't show the feedback page in landscape mode
    if (MediaQuery.of(context).orientation != Orientation.landscape) {
      await ctx.router.push(AppFeedbackSheet(source: FeedbackSource.navi));
    }
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
    }
  }

  // We hide metro layer on init of navigation because public transport goes thought the metro lines
  // and we don't want to mix it together with the route
  // TODO: Create `_metroOnDispose` to show metro layer when navigation is stopped
  // For this you have to change `layersControls` provider and detect previous state of layerControls
  //
  // For now we just hide layer
  Future<void> _metroOnInit() async {
    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      final layersControls = ref.read(layersControlsProvider.notifier);
      if (ref.read(layersControlsProvider).selectedType == LayerType.metro) {
        await layersControls.hideActiveLayer();
      }
    }
  }

  // Show the pause state
  Future<void> _onShowRoutePressed() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.showRoute,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
    sheetController.close();

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
      ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
      ref.read(currentRouteProvider.notifier).clearRoute();

      sheetController.close();

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
      if (_isLocationAccuracyAcceptable(position.latitude, position.longitude)) {
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
  }

  /// Checks if the distance between current position and route start point is reasonable
  bool _isLocationAccuracyAcceptable(double latitude, double longitude) {
    final routeStartPoint = ref.read(etaRouteInfoProvider).startPoint;
    if (routeStartPoint != null) {
      final distance = CommonFunctions.calculateDistance(
        latitude,
        longitude,
        routeStartPoint.lat,
        routeStartPoint.lon,
      );

      // If the calculated distance is more than 100 meters, the calculation error is too big
      if (distance > 70) {
        return false;
      }
    }

    return true;
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
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
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
}
