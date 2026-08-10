import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
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
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/pages/path_nav/path_nav_wrapper.dart';
import 'package:mapness/pages/routing/route_details_sheet.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/common_functions.dart' as cf;
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  const PathNavPage({required this.navType, required this.initAction, this.isHomeOrWork = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> with WidgetsBindingObserver {
  final panelKey = GlobalKey();
  bool _isSwitchingToPedestrian = false;
  bool _finishedByEta = false;
  bool _arrivalToastShown = false;
  bool _isEndingTrip = false;

  // Cache for indoor support check to avoid network delay on arrival
  bool? _cachedIndoorSupport;

  static const padding = EdgeInsets.symmetric(horizontal: 12);

  late final ValueNotifier<double> _bottomHeightNotifier = ValueNotifier(uikit.Spacing.$3x);
  final _navigationState = ValueNotifier(PathNavState.running);
  final _betterRouteDurationProfit = ValueNotifier<int?>(null);
  final isControlsActive = ValueNotifier(true);
  final isSwitchingToFoot = ValueNotifier(false);

  StreamSubscription? _naviEventsListener;
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
      // Re-sync sound settings from persistence in case CarPlay/Android Auto
      // changed the setting while the phone app was backgrounded.
      ref.read(soundSettingsProvider.notifier).syncFromPersistence();
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
    context.changeSystemNavBar();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    WidgetsBinding.instance.removeObserver(this);
    _naviEventsListener?.cancel();
    _bottomHeightNotifier.dispose();
    _betterRouteDurationProfit.dispose();
    _navigationState.dispose();
    timer?.cancel();
    WakelockPlus.disable();
    isSwitchingToFoot.dispose();
    super.dispose();
  }

  Future<void> saveNavigationState() async {
    // Public transport (Metro) never starts the native navigator (NavigationHandler
    // skips navigationManager.start for PT), so the SDK would pack an empty DISABLED
    // state here. Persisting it on every lock poisons the restore path with a state
    // that can never be restored (BALADY-3790).
    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      return;
    }

    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }

    final state = await dgisController.saveNavigationState();
    if (!mounted) {
      return;
    }

    await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateKey, base64.encode(state));
    await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateTypeKey, widget.navType.name);
  }

  Future<bool> restoreNavigationState() async {
    // There is no native navigation session to restore for public transport: the
    // active Metro route lives in the route editor and is streamed through
    // activePublicTransportRouteProvider. Falling through to the generic restore
    // would always fail for PT (getCurrentNavigationState reports disabled and the
    // packed state has no route) and pop the page, resetting the active Metro trip
    // after device lock/unlock (BALADY-3790).
    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      return true;
    }

    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return false;
    }

    final savedState = ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateKey);
    if (savedState == null) {
      final navState = await dgisController.getCurrentNavigationState();
      if (!mounted) {
        return false;
      }

      final hasActiveNavigation = navState.state == NavigationState.navigation && navState.routeSearchOptions != null;
      if (hasActiveNavigation) {
        return true;
      }

      await clearNavigationState();
      if (mounted && context.router.canPop()) {
        context.router.pop();
      }
      return false;
    }

    final state = base64.decode(savedState);
    try {
      await dgisController.restoreNavigationState(state, NavigationConstants.navigationSpeedRangeZooms);
      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }
      await clearNavigationState();
      if (mounted && context.router.canPop()) {
        context.router.pop();
      }
      return false;
    }
  }

  Future<void> clearNavigationState() async {
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateKey);
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateTypeKey);
  }

  Future<void> isNavigationUser() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final isNavUser = sharedPrefs.getBool('isNavigationUser') ?? false;
    if (!isNavUser) {
      ref.read(appAnalyticsProvider).isNavigationUser(isNavUser: true);
      await sharedPrefs.setBool('isNavigationUser', true);
    }
  }

  Future<void> _applyInitialPadding() async {
    if (mounted) {
      // await Future.delayed(const Duration(milliseconds: 200)); // Small delay for animation to render
      // if (!mounted) {
      //   return;
      // }

      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      if (isPortrait && widget.navType != RouteSearchOptionsMessage.publicTransport) {
        const stableInset = uikit.Spacing.$3x;
        final stableBottomInset = MediaQuery.paddingOf(context).bottom == 0 ? stableInset : 0;
        final bottomHeight = sheetController.sheetHeight + uikit.Spacing.$3x + uikit.Spacing.$4x + stableBottomInset;

        _bottomHeightNotifier.value = bottomHeight;
        _setPaddingToCamera(bottomHeight);
      }
    }
  }

  Future<void> _initNavigation() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }

    await _naviEventsListener?.cancel();
    if (!mounted) {
      return;
    }

    _naviEventsListener = dgisController.navigationEvents.listen(_naviEvent);

    if (widget.initAction == PathNavPageInitAction.startNavigation) {
      unawaited(isNavigationUser());
      await dgisController.startNavigation(NavigationConstants.navigationSpeedRangeZooms);
      if (!mounted) {
        return;
      }
      await _moveCameraToUser();
      if (!mounted) {
        return;
      }
      await _applyInitialPadding();
      await saveNavigationState();
    } else {
      final restored = await restoreNavigationState();
      if (!mounted) {
        return;
      }
      if (!restored) {
        return;
      }
      // After restore, move camera close without forcing follow to avoid zoom flicker
      await _moveCameraToUser(followAfter: false);
      await _applyInitialPadding();
    }

    if (widget.navType == RouteSearchOptionsMessage.car) {
      unawaited(_prefetchIndoorInfo());
    }
  }

  Future<void> _prefetchIndoorInfo() async {
    try {
      final finishPoint = ref.read(currentNavigationDestinationProvider);
      final dgisController = await ref.read(dgisControllerProvider.future);

      if (finishPoint?.dgisObjectId != null) {
        final objectInfo = await dgisController.searchByObjectId(finishPoint!.dgisObjectId!);
        final hasLevels = objectInfo.buildingLevels?.levels.isNotEmpty ?? false;
        final hasExplicitLevel = finishPoint.levelId != null || objectInfo.levelId != null;

        if (mounted) {
          setState(() {
            _cachedIndoorSupport = hasLevels || hasExplicitLevel;
          });
        }
      }
    } catch (e) {
      // Ignore errors during prefetch, we will fallback to normal check if needed
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
    const stableInset = uikit.Spacing.$3x;

    sheetController = useToggleSheetController(onClose: (_) {}, clipByHeader: true, resetContentScrollOnClosed: true)
      ..updateHeightModel(isPortrait ? null : ToggleSheetHeightModel.offset(stableInset));
    final stableBottomInset = MediaQuery.paddingOf(context).bottom == 0 ? stableInset : 0;

    void onSheetHeightChanged() {
      if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
        return;
      }
      if (isPortrait) {
        final sheetHeight = sheetController.sheetHeight + uikit.Spacing.$3x + uikit.Spacing.$4x + stableBottomInset;

        if (_bottomHeightNotifier.value != sheetHeight) {
          _bottomHeightNotifier.value = sheetHeight;
          _setPaddingToCamera(_bottomHeightNotifier.value);
        }
        return;
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

      if (isPortrait && widget.navType != RouteSearchOptionsMessage.publicTransport) {
        final bottomHeight = sheetController.sheetHeight + uikit.Spacing.$3x + uikit.Spacing.$4x + stableBottomInset;
        _bottomHeightNotifier.value = bottomHeight;
      }

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
        final connected = next.value ?? false;
        final shouldEndTrip =
            connected &&
            widget.navType != RouteSearchOptionsMessage.car &&
            _navigationState.value != PathNavState.finished;
        if (shouldEndTrip) {
          unawaited(_endTripAndShowHome());
        }
      })
      ..listen(pathNavEtaProvider, (previous, next) {
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

          // Fallback: finish pedestrian trip when very close to destination
          final shouldFinishByEta =
              widget.navType == RouteSearchOptionsMessage.pedestrian &&
              !_finishedByEta &&
              distance != null &&
              distance <= 5;
          if (shouldFinishByEta) {
            _finishedByEta = true;
            _finishNavigation();
            if (mounted) {
              unawaited(_endTripAndShowHome());
            }
          }
        }
      })
      ..listen(dgisControllerProvider, (previous, next) {
        if (next.hasValue && previous?.value != next.value) {
          _initNavigation();
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
              Builder(
                builder: (context) {
                  final startPoint = ref.read(etaRouteInfoProvider).startPoint;
                  final destination = ref.read(etaRouteInfoProvider).endPoint;
                  if (startPoint == null || destination == null) {
                    return const SizedBox.shrink();
                  }
                  return RouteDetailsPage(
                    type: RouteDetailsSheetType.driving,
                    startPoint: RouteParamsPointWithLabel(
                      label: startPoint.label ?? '',
                      value: RouteParamsPoint(latitude: startPoint.lat ?? 0, longitude: startPoint.lon ?? 0),
                    ),
                    destination: RouteParamsPointWithLabel(
                      label: destination.label ?? '',
                      value: RouteParamsPoint(latitude: destination.lat ?? 0, longitude: destination.lon ?? 0),
                    ),
                    publicTransportRoutes: [publicRoute],
                    onSheetHeightChanged: isPortrait
                        ? (height) {
                            final totalHeight = height + uikit.Spacing.$3x + uikit.Spacing.$4x + stableBottomInset;
                            if (_bottomHeightNotifier.value != totalHeight) {
                              _bottomHeightNotifier.value = totalHeight;
                              _setPaddingToCamera(_bottomHeightNotifier.value);
                            }
                          }
                        : null,
                    onPressed: () async {
                      // Remove route from the map for public transport
                      await ref.read(dgisControllerProvider).value?.hideRoutes();
                      await _endTripAndShowFeedback(context);
                    },
                    onClose: () async {
                      await ref.read(dgisControllerProvider).value?.hideRoutes();
                      await _endTripAndShowFeedback(context);
                    },
                    buttonLabel: context.l10n.endTrip,
                  );
                },
              ),
            if (widget.navType != RouteSearchOptionsMessage.publicTransport)
              PathNavWrapper(
                isPortrait: isPortrait,
                indoorControl: widget.navType == RouteSearchOptionsMessage.pedestrian
                    ? const Padding(padding: padding, child: IndoorControl())
                    : null,
                child: NaviSheetPanel(
                  key: panelKey,
                  isSwitchingToFoot: isSwitchingToFoot,
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
    if (_isEndingTrip) {
      return;
    }
    _isEndingTrip = true;
    final route = ref.read(etaRouteInfoProvider);
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    unawaited(_sendNavigationCompletedAnalytics(route));

    await Future.wait([
      ref.read(dgisControllerProvider).value?.hideRoutes() ?? Future.value(),
      _stopActiveSharing(),
      ref.read(cameraPaddingProvider.notifier).resetPadding(),
    ]);

    if (_navigationState.value != PathNavState.finished) {
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.navigationRoutingHalfway);
      ref
          .read(advertMetricsProvider.notifier)
          .sendEvent(AdvertMetricsKeys.journeyHalfwayUnique, isUniquePerSession: true);
    }

    // Always stop navigation to ensure engine is fully terminated
    try {
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
    } catch (_) {}
    try {
      await ref.read(dgisControllerProvider).value?.stopNavigation();
    } catch (_) {}

    ref.read(currentRouteProvider.notifier).clearRoute();

    await Future.wait([
      if (widget.navType == RouteSearchOptionsMessage.publicTransport)
        ref.read(dgisControllerProvider).value?.hideRoutes() ?? Future.value(),
      clearNavigationState(),
      ref.read(selectedMarkerProvider.notifier).removeAllMarkers(),
    ]);

    ref.read(layersControlsProvider.notifier).updateLayerInfo();

    ref.read(searchProvider(SearchScopeEnum.map.value).notifier).clear();
    final mapSettings = MapObjectManagerSettings.search();
    final mapObjectProvider = ref.read(
      mapObjectManagerProvider(named: mapSettings.name, layerId: mapSettings.layerId).notifier,
    );

    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: true);

    if (isLandscape) {
      await context.router.push(const FlipsContinueRoute());
      action?.call();
      return;
    }

    action?.call();
  }

  Future<void> _sendNavigationCompletedAnalytics(EtaRoute route) async {
    try {
      final pathInfo = ref.read(pathNavEtaProvider);
      final location = ref.read(cityByLocationProvider.notifier);
      //!
      final appAnalytics = ref.read(appAnalyticsProvider);
      final results = await Future.wait([
        location.getCityByLatLng(lat: route.startPoint?.lat, lng: route.startPoint?.lon),
        location.getCityByLatLng(lat: route.endPoint?.lat, lng: route.endPoint?.lon),
      ]);
      final originCity = results[0];
      final destinationCity = results[1];

      appAnalytics.navigationCompleted(
        origin: route.startPoint?.analyticsLabel ?? '',
        destination: route.endPoint?.analyticsLabel ?? '',
        originCity: originCity.name,
        destinationCity: destinationCity.name,
        spentTime: pathInfo?.spentTime ?? Duration.zero,
      );
    } catch (_) {
      // Analytics failure should not affect trip ending
    }
  }

  // Show the route page after the trip is finished
  Future<void> _endTripAndBuildAnotherRoute() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndBuildAnother,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );

    await _endTrip(
      action: () {
        if (context.mounted) {
          context.router.navigate(const RoutingPointsRoute());
        }
      },
    );
  }

  // Show the home page after the trip is finished
  Future<void> _endTripAndShowHome() async {
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);

    await _endTrip(
      action: () {
        if (mounted) {
          context.router.popUntilRouteWithName(BottomMenuRoute.name);
        }
      },
    );

    // After returning home, show "You arrived" toast once
    if (!_arrivalToastShown) {
      _arrivalToastShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final toastCtx = rootNavigatorKey.currentContext ?? context;
        if (toastCtx.mounted) {
          ToastOverlay.of(toastCtx).show(title: context.l10n.youArrived);
        }
      });
    }
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

    final parkingManage =
        ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value == null;
    final position = ref.read(locationProvider);

    if (widget.navType == RouteSearchOptionsMessage.car) {
      ToastOverlay.of(context).show(
        displayDuration: const Duration(seconds: 3),
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
        icon: ToastIconAsset(switch (context.read<ThemeController>().currentTheme) {
          BaladyAppThemes.darkDGA => Assets.icons.svg.placesBigNew.dark.icParking.keyName,
          BaladyAppThemes.lightDGA => Assets.icons.svg.placesBigNew.light.icParking.keyName,
          _ => Assets.icons.svg.placesBigNew.light.icParking.keyName,
        }),
      );
    }

    if (!mounted) {
      return;
    }

    // We don't show the feedback page in landscape mode
    if (MediaQuery.of(context).orientation != Orientation.landscape) {
      await ctx.router.push(AppFeedbackSheet(source: const FeedbackSource.navi()));
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
    await ref.read(dgisControllerProvider).value?.showRoutes();
  }

  // Continue the trip after the pause state
  Future<void> _onContinuePressed() async {
    _navigationState.value = PathNavState.running;
    final dgisController = await ref.read(dgisControllerProvider.future);
    await _moveCameraToUser();
    await dgisController.followNavigation();
    await dgisController.hideRoutes();
  }

  // Notify the listeners about the end of the trip
  Future<void> _naviEvent(NavigationEvent event) async {
    // PT never starts the native navigator, so navigation state events can only
    // originate from other flows sharing the NavigationManager (free roam, CarPlay,
    // Android Auto). They must not end an active Metro trip (BALADY-3790); PT trips
    // end via the end-trip button or the carConnectionProvider listener.
    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      return;
    }

    switch (event) {
      case NavigationEvent.navigation:
      case NavigationEvent.routeSearch:
        break;
      case NavigationEvent.disabled:
        if (_isSwitchingToPedestrian) {
          return;
        }
        if (context.mounted && _navigationState.value != PathNavState.finished) {
          unawaited(_endTripAndShowHome());
        }
        break;
      case NavigationEvent.finished:
        if (widget.navType == RouteSearchOptionsMessage.car) {
          _isSwitchingToPedestrian = true;
          _checkAndSwitchToPedestrian();
          return;
        }
        // If pedestrian navigation finished, ensure trip ends and navigate home
        await _finishNavigation();
        if (mounted) {
          unawaited(_endTripAndShowHome());
        }
        break;
    }
  }

  Future<void> _finishNavigation() async {
    // iOS: DGis "arrival" voice can stop in-app radio. Capture current state so we can
    // restore it after the voice finishes (best-effort, delayed).
    final streamAudioWasPlayingBeforeFinish = ref.read(streamAudioProvider).isEffectivelyPlaying;

    _sendAnalitycs();
    _navigationState.value = PathNavState.finished;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    ref.read(layersControlsProvider.notifier).hideParking();
    ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
    ref.read(currentRouteProvider.notifier).clearRoute();
    sheetController.close();
    unawaited(clearNavigationState());
    unawaited(_stopActiveSharing());

    // Restore in-app stream audio when navigation finishes normally.
    // We delay because the DGis arrival prompt is played around this time on iOS.
    if (streamAudioWasPlayingBeforeFinish) {
      unawaited(
        Future<void>.delayed(const Duration(seconds: 4), () async {
          if (!mounted) {
            return;
          }
          final streamAudio = ref.read(streamAudioProvider);
          if (!streamAudio.isEffectivelyPlaying && !streamAudio.isLoading) {
            await ref.read(streamAudioProvider).togglePlayPause();
          }
        }),
      );
    }
  }

  void _sendAnalitycs() {
    ref.read(urbiAnalyticsProvider).track('tripCompleted');
    ref
        .read(advertMetricsProvider.notifier)
        .sendEvent(
          AdvertMetricsKeys.navigationRoutingCompleted,
        );
    ref
        .read(advertMetricsProvider.notifier)
        .sendEvent(
          AdvertMetricsKeys.journeyCompleteUnique,
          isUniquePerSession: true,
        );
  }

  Future<void> _checkAndSwitchToPedestrian() async {
    isSwitchingToFoot.value = true;
    try {
      final finishPoint = ref.read(currentNavigationDestinationProvider);
      final location = ref.read(locationProvider);
      final dgisController = ref.read(dgisControllerProvider).value;

      if (finishPoint == null || location == null || dgisController == null) {
        await _finishNavigation();
        if (mounted) {
          await _endTripAndShowHome();
        }
        return;
      }
      final distance = cf.CommonFunctions.distance(
        location.latitude,
        location.longitude,
        finishPoint.geoPoint.latitude,
        finishPoint.geoPoint.longitude,
      );

      // If distance > 20 meters, check for indoor support (switch to pedestrian)
      if (distance > 0.02) {
        bool supportsIndoor = false;
        // Check if we have objectId to fetch building info
        if (finishPoint.dgisObjectId != null) {
          try {
            if (_cachedIndoorSupport != null) {
              supportsIndoor = _cachedIndoorSupport!;
            } else {
              final objectInfo = await dgisController.searchByObjectId(finishPoint.dgisObjectId!);

              // Check for building levels (indoor map support)
              if (objectInfo.buildingLevels != null && (objectInfo.buildingLevels?.levels.isNotEmpty ?? false)) {
                supportsIndoor = true;
              }

              // Fallback: update supportsIndoor if levelId is explicitly set in destination
              if (finishPoint.levelId != null || objectInfo.levelId != null) {
                supportsIndoor = true;
              }
            }
          } catch (e) {
            logger.log('Error fetching object info for pedestrian switch: $e', logLevel: MapnessLogLevel.error);
          }
        }

        if (supportsIndoor) {
          // Switch to pedestrian
          final startPoint = RouteParamsPoint(latitude: location.latitude, longitude: location.longitude);
          final points = [startPoint, finishPoint];
          final intermediatePoints = points.getIntermediatePoints();

          ref.read(
            routesProvider(
              startPoint: startPoint,
              finishPoint: finishPoint,
              navType: RouteSearchOptionsMessage.pedestrian,
              intermediatePoints: intermediatePoints,
              showOnlyActiveRoute: true,
            ),
          );

          // Navigate to new navigation session
          if (mounted) {
            // Start navigation on the newly calculated route
            await dgisController.startNavigation(NavigationConstants.navigationSpeedRangeZooms);

            // Save the navigation state so it can be restored on the new page
            final state = await dgisController.saveNavigationState();
            await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateKey, base64.encode(state));
            await ref
                .read(sharedPrefsProvider)
                .setString(MapnessConstants.navigatorStateTypeKey, RouteSearchOptionsMessage.pedestrian.name);

            // Avoid pre-replace zoom to reduce flicker; we will adjust after restore

            // Replace current page with pedestrian navigation
            // Set to false before navigating to avoid keeping the overlay if something goes wrong during replacement
            isSwitchingToFoot.value = false;
            await context.router.replace(
              PathNavRoute(
                navType: RouteSearchOptionsMessage.pedestrian,
                isHomeOrWork: widget.isHomeOrWork,
                initAction: PathNavPageInitAction.restoreFromState,
              ),
            );
            return;
          }
        }
      }
      _isSwitchingToPedestrian = false;
      await _finishNavigation();
      if (mounted) {
        await _endTripAndShowHome();
      }
    } finally {
      if (mounted) {
        isSwitchingToFoot.value = false;
      }
    }
  }

  Future<void> _moveCameraToUser({double targetZoom = 17.5, bool followAfter = true}) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final position = ref.read(locationProvider);
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    if (position != null) {
      if (_isLocationAccuracyAcceptable(position.latitude, position.longitude)) {
        await cameraProvider.animateTo(
          CameraPositionMessage(
            point: GeoPointMessage(latitude: position.latitude, longitude: position.longitude),
            zoom: 17.5,
            tilt: 50,
            bearing: 0,
          ),
        );
      }
    }

    if (followAfter) {
      await dgisController.startFollowNavigation();
      if (position != null) {
        if (_isLocationAccuracyAcceptable(position.latitude, position.longitude)) {
          await cameraProvider.animateTo(
            CameraPositionMessage(
              point: GeoPointMessage(latitude: position.latitude, longitude: position.longitude),
              zoom: 17.5,
              tilt: 50,
              bearing: 0,
            ),
          );
        }
      }
    }
  }

  /// Checks if the distance between current position and route start point is reasonable
  bool _isLocationAccuracyAcceptable(double latitude, double longitude) {
    final routeStartPoint = ref.read(etaRouteInfoProvider).startPoint;
    if (routeStartPoint != null) {
      final distance = CommonFunctions.calculateDistance(latitude, longitude, routeStartPoint.lat, routeStartPoint.lon);

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
          ref
              .read(cameraPaddingProvider.notifier)
              .setPadding(CameraSetPaddingMessage(bottomPadding: (pixelSize * padding).floor()));
        }
      case Orientation.landscape:
        ref.read(cameraPaddingProvider.notifier).setPadding(CameraSetPaddingMessage());
    }
  }

  Future<void> _acceptBetterRoute(BuildContext context) async {
    _betterRouteDurationProfit.value = null;
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.betterRouteResponse(BetterRouteResponseMessage.accept);

    // Keep running-navigation map state consistent after accepting better route:
    // route overlays (with time indicators) must be hidden in follow mode.
    if (_navigationState.value == PathNavState.running) {
      await dgisController.followNavigation();
      await dgisController.hideRoutes();
    }
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
    final mapObjectProvider = ref.read(
      mapObjectManagerProvider(named: mapSettings.name, layerId: mapSettings.layerId).notifier,
    );

    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: true);
    await context.router.push(NaviSearchRoute(isPathNavScreen: true));
    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: false);
  }
}
