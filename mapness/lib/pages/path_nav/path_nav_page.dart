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
import 'package:geolocator/geolocator.dart' show Position;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/entities/path_nav/models/pedestrian_transition_config.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/features/path_nav/providers/active_public_transport_route.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/features/path_nav/providers/pedestrian_transition_config.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/features/tifo/tifo_trip_rewards.dart';
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
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
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
import 'package:mapness/shared/services/navigation_live_updates.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/detach.dart';
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

  // Set from the moment the user accepts the switch until the page is replaced.
  // Guards against double taps and against the countdown cancel firing mid-switch.
  bool _pedestrianSwitchInProgress = false;
  bool _finishedByEta = false;
  bool _isEndingTrip = false;
  // Guards `_finishNavigation` against firing more than once for the same
  // trip: the SDK's `finished` event, the ETA<=5m fallback, and the
  // pedestrian-switch fallback can each independently trigger it, and
  // without this every extra call sends its own TIFO trip-reward request
  // (each with a fresh random tripId, so the backend can't dedupe them).
  bool _navigationFinishReported = false;

  // Restoring navigation restarts it on the native side, which emits transient
  // disabled/finished events before the restored navigation actually starts.
  // Ignore end-of-trip events until the first `navigation` event arrives.
  bool _ignoreEndEventsUntilNavigation = false;

  // Cache for indoor support check to avoid network delay on arrival
  bool? _cachedIndoorSupport;
  bool _indoorPrefetchInFlight = false;

  // Car → pedestrian transition prompt state (see PedestrianTransitionConfig).
  bool _showPedestrianPrompt = false;

  // While driving a dismissal only hides the prompt; after arrival it ends the trip.
  bool _pedestrianPromptOnArrival = false;
  int _pedestrianPromptShownCount = 0;
  DateTime? _pedestrianPromptDismissedAt;

  // Don't offer a pedestrian route when the destination is closer than this.
  static const _minPedestrianRouteDistanceMeters = 10.0;

  PedestrianTransitionConfig get _transitionConfig => ref.read(pedestrianTransitionConfigProvider);

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
      if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
        // PT never starts the native navigator, so the engine always reports
        // disabled - reconciling below would end the Metro trip on every
        // unlock. Re-show the route overlay instead (BALADY-3790).
        unawaited(_resyncPublicTransportRoute());
      } else {
        // The trip may have ended natively (CarPlay / Android Auto, or the engine
        // itself) while the app was backgrounded — reconcile UI with the engine.
        unawaited(_reconcileNavigationOnResume());
      }
    }
  }

  /// If the navigation engine was stopped externally (e.g. the trip was ended
  /// from CarPlay while the Dart isolate was paused), close the page.
  Future<void> _reconcileNavigationOnResume() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted || _isEndingTrip || _isSwitchingToPedestrian) {
      return;
    }

    final navState = await dgisController.getCurrentNavigationState();
    if (!mounted || _isEndingTrip || _isSwitchingToPedestrian) {
      return;
    }

    final engineStopped = navState.state == NavigationState.disabled;
    final pageStillNavigating = _navigationState.value != PathNavState.finished;
    if (engineStopped && pageStillNavigating) {
      unawaited(_endTripAndShowHome());
    }
  }

  // Public transport never starts the native navigator (see saveNavigationState
  // below), so its route overlay has no session to restore from a lock/unlock
  // cycle - it depends entirely on the route editor's map source staying
  // rendered. Re-issue showRoutes() on resume to force it back on screen in
  // case the map dropped it while the app was backgrounded (BALADY-3790).
  Future<void> _resyncPublicTransportRoute() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }
    await dgisController.showRoutes();
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
      detach(soundSettingsNotifier.muteNavigationSound(), tag: 'pathNav.muteSound');
    } else if (state == AppLifecycleState.resumed) {
      detach(soundSettingsNotifier.restoreNavigationSound(), tag: 'pathNav.restoreSound');
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
  void didUpdateWidget(covariant PathNavPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navType != oldWidget.navType ||
        widget.initAction != oldWidget.initAction ||
        widget.isHomeOrWork != oldWidget.isHomeOrWork) {
      _initNavigation();
    }
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

    // Belt-and-braces: the native side also ends the session on engine state,
    // but make sure the widget is removed on any in-app trip end path. Skipped
    // during the car -> pedestrian switch — the session continues on foot.
    if (!_isSwitchingToPedestrian) {
      unawaited(NavigationLiveUpdates.instance.endSession());
    }

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
    final savedType = ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateTypeKey);
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
      final restoredState = await dgisController.getCurrentNavigationState();
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
    // New navigation session: reset the transition prompt state (TP-05 / TP-06).
    _showPedestrianPrompt = false;
    _pedestrianPromptOnArrival = false;
    _pedestrianPromptShownCount = 0;
    _pedestrianPromptDismissedAt = null;
    _cachedIndoorSupport = null;
    _ignoreEndEventsUntilNavigation = widget.initAction == PathNavPageInitAction.restoreFromState;
    if (!mounted) {
      return;
    }

    await _naviEventsListener?.cancel();
    if (!mounted) {
      return;
    }

    _naviEventsListener = dgisController.navigationEvents.listen(_naviEvent);

    if (widget.initAction == PathNavPageInitAction.startNavigation) {
      // Analytics only - these must not delay `startNavigation` below.
      detach(isNavigationUser(), tag: 'pathNav.isNavigationUser');
      detach(_trackNavigationStarted(), tag: 'pathNav.trackStarted');
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

    unawaited(_syncLiveUpdatesMetadata());

    if (widget.navType == RouteSearchOptionsMessage.car) {
      detach(_prefetchIndoorInfo(), tag: 'pathNav.prefetchIndoor');
    }
  }

  /// Phase-1 `navigation_started` (docs/analytics-tracking-plan.md). Planned
  /// distance/ETA come from the route selected on the routing screen; the head
  /// unit is derived from the CarPlay/Android Auto connection state.
  Future<void> _trackNavigationStarted() async {
    final plannedRoute = ref.read(currentRouteProvider)?.route;
    var carConnected = false;
    try {
      carConnected = await ref.read(carConnectionProvider.future);
    } catch (_) {
      // Unknown connection state counts as no head unit.
    }
    BaladyNavigationEvents.trackNavigationStarted(
      navType: widget.navType,
      carConnected: carConnected,
      plannedDistanceM: plannedRoute?.distance,
      plannedDurationSec: plannedRoute?.duration,
    );
  }

  Future<void> _syncLiveUpdatesMetadata() async {
    if (!mounted) {
      return;
    }
    final destination = ref.read(etaRouteInfoProvider).endPoint;
    final l10n = context.l10n;
    await NavigationLiveUpdates.instance.setSessionMetadata(
      destinationName: destination?.label,
      routeType: widget.navType.name,
      language: ref.read(appLanguageProvider).baladyCompat,
      // Keys the native widgets look up; anything absent keeps its native default.
      strings: <String, String>{
        'arrived': l10n.youArrived,
        'gps_lost': l10n.gpsLost,
        'free_roam': l10n.freeRoam,
        'reroute': l10n.routeResearch,
        'km': l10n.km,
        'm': l10n.meter,
        'h': l10n.hoursShort,
        'min': l10n.minutesShort,
      },
    );
  }

  Future<void> _prefetchIndoorInfo() async {
    if (_indoorPrefetchInFlight || _cachedIndoorSupport != null) {
      return;
    }
    _indoorPrefetchInFlight = true;
    try {
      final finishPoint = ref.read(currentNavigationDestinationProvider);
      if (finishPoint == null) {
        return;
      }
      if (finishPoint.dgisObjectId == null) {
        _cachedIndoorSupport = finishPoint.levelId != null;
        return;
      }

      final dgisController = await ref.read(dgisControllerProvider.future);
      final objectInfo = await dgisController.searchByObjectId(finishPoint.dgisObjectId!);
      final hasLevels = objectInfo.buildingLevels?.levels.isNotEmpty ?? false;
      final hasExplicitLevel = finishPoint.levelId != null || objectInfo.levelId != null;
      _cachedIndoorSupport = hasLevels || hasExplicitLevel;
    } catch (e) {
      // Ignore errors during prefetch, the next evaluation retries
      logger.log('Error prefetching indoor info: $e', logLevel: MapnessLogLevel.error);
    } finally {
      _indoorPrefetchInFlight = false;
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
          detach(_endTripAndShowHome(), tag: 'pathNav.endTripOnCarConnect');
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
            // These two used to run in parallel: the dropped `_finishNavigation()`
            // was still clearing the native navigation state and the route while
            // `_endTripAndShowHome` was already popping home. Chained now, the
            // way the `NavigationEvent.finished` branch below already does it.
            detach(
              _finishNavigation().then((_) {
                if (!mounted) {
                  return Future<void>.value();
                }
                return _endTripAndShowHome();
              }),
              tag: 'pathNav.finishByEta',
            );
          }
        }
      })
      ..listen(dgisControllerProvider, (previous, next) {
        if (next.hasValue && previous?.value != next.value) {
          _initNavigation();
        }
      })
      // Location updates keep coming while the user is stationary, so this also
      // re-evaluates the prompt after the re-display interval expires.
      ..listen(locationProvider, (_, _) => _maybeShowPedestrianPrompt());

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
                  showPedestrianPrompt: _showPedestrianPrompt,
                  pedestrianPromptAutoDismiss: _transitionConfig.promptAutoDismissInterval,
                  isSwitchingToFoot: isSwitchingToFoot,
                  onSwitchToPedestrian: _switchToPedestrian,
                  onCancelSwitchToPedestrian: onCancelSwitchToPedestrian,
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

    // Phase-1 navigation_completed / navigation_cancelled — read progress
    // sources before the route/navigation state is torn down below.
    final pathInfo = ref.read(pathNavEtaProvider);
    final plannedRoute = ref.read(currentRouteProvider)?.route;
    BaladyNavigationEvents.trackNavigationEnded(
      navType: widget.navType,
      arrivedDetected: _navigationState.value == PathNavState.finished || _finishedByEta,
      plannedDistanceM: plannedRoute?.distance,
      plannedDurationSec: plannedRoute?.duration,
      remainingDistanceM: pathInfo?.rawDistance,
      spentTime: pathInfo?.spentTime,
    );

    detach(_sendNavigationCompletedAnalytics(route), tag: 'pathNav.completedAnalytics');

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

    if (widget.navType == RouteSearchOptionsMessage.publicTransport) {
      ref.read(freeRoamStarterProvider.notifier).reset();
    }

    ref.read(layersControlsProvider.notifier).updateLayerInfo();

    ref.read(searchProvider(SearchScopeEnum.map.value).notifier).clear();
    final mapSettings = MapObjectManagerSettings.search();
    final mapObjectProvider = ref.read(
      mapObjectManagerProvider(named: mapSettings.name, layerId: mapSettings.layerId).notifier,
    );

    await mapObjectProvider.setMapObjectManagerIsVisible(isVisible: true);

    if (isLandscape) {
      // ~6 awaits above; the page can be gone by now.
      if (mounted) {
        await context.router.push(const FlipsContinueRoute());
      }
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
    // No arrival toast here: core moved the "You arrived" string into the
    // native live-updates widgets, which also removes the crash source this
    // fix originally targeted (a post-frame callback touching the popped
    // State's context - 1.1k events / 816 users on 3.13.5).
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
        _ignoreEndEventsUntilNavigation = false;
        break;
      case NavigationEvent.routeSearch:
        // The engine recalculates the route mid-guidance (off-route/reroute) —
        // counted into navigation_completed.reroutes_count.
        BaladyNavigationEvents.trackReroute();
        break;
      case NavigationEvent.disabled:
        if (_isSwitchingToPedestrian || _ignoreEndEventsUntilNavigation) {
          return;
        }
        if (context.mounted && _navigationState.value != PathNavState.finished) {
          await _endTripAndShowHome();
        }
        break;
      case NavigationEvent.finished:
        if (_ignoreEndEventsUntilNavigation) {
          return;
        }
        if (widget.navType == RouteSearchOptionsMessage.car) {
          if (_pedestrianSwitchInProgress) {
            return;
          }
          if (_showPedestrianPrompt) {
            // The prompt is already on screen from the while-driving evaluation.
            // From now on dismissing it must end the trip: the car navigation is over.
            _pedestrianPromptOnArrival = true;
            _isSwitchingToPedestrian = true;
            return;
          }
          _isSwitchingToPedestrian = true;
          await _checkAndSwitchToPedestrian();
          return;
        }
        // If pedestrian navigation finished, ensure trip ends and navigate home
        await _finishNavigation();
        if (mounted) {
          await _endTripAndShowHome();
        }
        break;
    }
  }

  Future<void> _finishNavigation() async {
    if (_navigationFinishReported) {
      return;
    }
    _navigationFinishReported = true;

    // iOS: DGis "arrival" voice can stop in-app radio. Capture current state so we can
    // restore it after the voice finishes (best-effort, delayed).
    final streamAudioWasPlayingBeforeFinish = ref.read(streamAudioProvider).isEffectivelyPlaying;

    _sendAnalitycs();
    // TIFO US-16: a completed trip earns tokens. Fire-and-forget — the backend
    // validates and rewards; a signed-out user or a failed call is a no-op.
    // Read the route's distance now, before `clearRoute()` below wipes it.
    final tripDistanceKm = (ref.read(currentRouteProvider)?.route.distance ?? 0) / 1000;
    detach(reportTifoTripCompleted(ref, distanceKm: tripDistanceKm), tag: 'pathNav.tifoTripCompleted');
    _navigationState.value = PathNavState.finished;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    await ref.read(layersControlsProvider.notifier).hideParking();
    ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
    ref.read(currentRouteProvider.notifier).clearRoute();
    sheetController.close();
    // Awaited: callers treat `_finishNavigation` completing as "navigation is
    // fully torn down", and partially cleared native navigation state is what
    // leaves the next trip restoring a stale session.
    await clearNavigationState();
    await _stopActiveSharing();
    if (!mounted) {
      return;
    }

    // Restore in-app stream audio when navigation finishes normally.
    // We delay because the DGis arrival prompt is played around this time on iOS.
    if (streamAudioWasPlayingBeforeFinish) {
      detach(
        Future<void>.delayed(const Duration(seconds: 4), () async {
          if (!mounted) {
            return;
          }
          final streamAudio = ref.read(streamAudioProvider);
          if (!streamAudio.isEffectivelyPlaying && !streamAudio.isLoading) {
            await ref.read(streamAudioProvider).togglePlayPause();
          }
        }),
        tag: 'pathNav.restoreStreamAudio',
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

  /// TP-01 / TP-02: proximity radius depends on whether the destination is an
  /// indoor POI (has an explicit level) or a regular building.
  double _proximityRadiusMetersFor(RouteParamsPoint finishPoint) => finishPoint.levelId != null
      ? _transitionConfig.indoorPoiProximityRadiusMeters
      : _transitionConfig.buildingProximityRadiusMeters;

  double _distanceToFinishMeters(Position location, RouteParamsPoint finishPoint) =>
      cf.CommonFunctions.distance(
        location.latitude,
        location.longitude,
        finishPoint.geoPoint.latitude,
        finishPoint.geoPoint.longitude,
      ) *
      1000;

  /// TP-05 / TP-06: whether the prompt is allowed to appear right now.
  bool get _promptDisplayAllowed {
    if (_pedestrianPromptShownCount >= _transitionConfig.maxPromptDisplayCount) {
      return false;
    }
    final dismissedAt = _pedestrianPromptDismissedAt;
    return dismissedAt == null || DateTime.now().difference(dismissedAt) >= _transitionConfig.promptRedisplayInterval;
  }

  void _showTransitionPrompt({required bool onArrival}) {
    _pedestrianPromptShownCount++;
    _pedestrianPromptOnArrival = onArrival;
    setState(() {
      _showPedestrianPrompt = true;
    });
  }

  /// Evaluates the outdoor → indoor transition conditions while the user is
  /// still driving and shows the switch-to-pedestrian prompt when they all pass.
  void _maybeShowPedestrianPrompt() {
    if (!mounted || widget.navType != RouteSearchOptionsMessage.car) {
      return;
    }
    if (_showPedestrianPrompt || _isSwitchingToPedestrian || _pedestrianSwitchInProgress) {
      return;
    }
    if (_navigationState.value != PathNavState.running) {
      return;
    }
    if (!_promptDisplayAllowed) {
      return;
    }

    final finishPoint = ref.read(currentNavigationDestinationProvider);
    final location = ref.read(locationProvider);
    if (finishPoint == null || location == null) {
      return;
    }

    // The destination must support indoor navigation.
    if (finishPoint.levelId == null) {
      if (_cachedIndoorSupport == null) {
        unawaited(_prefetchIndoorInfo());
        return;
      }
      if (!_cachedIndoorSupport!) {
        return;
      }
    }

    // TP-03: remaining ETA.
    final eta = ref.read(pathNavEtaProvider);
    if (eta == null || Duration(seconds: eta.durationInSeconds) > _transitionConfig.etaThreshold) {
      return;
    }

    // TP-04: current speed (km/h).
    if (ref.read(pathNavSpeedInfoProvider).speed > _transitionConfig.maxVehicleSpeedKmh) {
      return;
    }

    // TP-01 / TP-02: proximity to the destination.
    final distanceMeters = _distanceToFinishMeters(location, finishPoint);
    if (distanceMeters <= _minPedestrianRouteDistanceMeters ||
        distanceMeters > _proximityRadiusMetersFor(finishPoint)) {
      return;
    }

    _showTransitionPrompt(onArrival: false);
  }

  /// Arrival fallback: the car navigation finished before the while-driving
  /// evaluation proposed the transition (or the user drove past the prompt).
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

      final distanceMeters = _distanceToFinishMeters(location, finishPoint);
      final withinProximity =
          distanceMeters > _minPedestrianRouteDistanceMeters &&
          distanceMeters <= _proximityRadiusMetersFor(finishPoint);

      if (withinProximity && _promptDisplayAllowed) {
        bool supportsIndoor = finishPoint.levelId != null;
        if (!supportsIndoor) {
          await _prefetchIndoorInfo();
          supportsIndoor = _cachedIndoorSupport ?? false;
        }

        if (supportsIndoor && mounted) {
          _showTransitionPrompt(onArrival: true);
          return;
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

  Future<void> _switchToPedestrian() async {
    if (_pedestrianSwitchInProgress) {
      return;
    }
    _pedestrianSwitchInProgress = true;
    // The switch can also start mid-drive now, so make sure the transient
    // disabled/finished events from restarting navigation are ignored.
    _isSwitchingToPedestrian = true;

    // Hide the countdown banner immediately: disposing it also stops its timer,
    // so onTimeout can't cancel the trip while the switch is in flight.
    setState(() {
      _showPedestrianPrompt = false;
    });

    final finishPoint = ref.read(currentNavigationDestinationProvider);
    final dgisController = ref.read(dgisControllerProvider).value;
    final location = ref.read(locationProvider);
    if (finishPoint == null || location == null || dgisController == null) {
      _pedestrianSwitchInProgress = false;
      _isSwitchingToPedestrian = false;
      await _finishNavigation();
      if (mounted) {
        await _endTripAndShowHome();
      }
      return;
    }

    final startPoint = RouteParamsPoint(latitude: location.latitude, longitude: location.longitude);
    final points = [startPoint, finishPoint];
    final intermediatePoints = points.getIntermediatePoints();

    final pedestrianRoutesProvider = routesProvider(
      startPoint: startPoint,
      finishPoint: finishPoint,
      navType: RouteSearchOptionsMessage.pedestrian,
      intermediatePoints: intermediatePoints,
      showOnlyActiveRoute: true,
    );
    // The provider is autoDispose and nothing watches it here: hold a manual
    // subscription so it isn't disposed (cancelling the route search) mid-await.
    final routesSubscription = ref.listenManual(pedestrianRoutesProvider, (_, _) {});

    // wait route to build properly before starting navigation
    isSwitchingToFoot.value = true;
    try {
      final routes = await ref.read(pedestrianRoutesProvider.future);
    } catch (e) {
      logger.log('PathNavPage: failed to build pedestrian route: $e', logLevel: MapnessLogLevel.error);
      if (mounted) {
        _showPedestrianSwitchError(e);
        isSwitchingToFoot.value = false;
        _isSwitchingToPedestrian = false;
        _pedestrianSwitchInProgress = false;
        // Apply the re-display interval so the prompt doesn't pop right back up.
        _pedestrianPromptDismissedAt = DateTime.now();
        // While driving the car navigation is still running — just keep going.
        // On arrival there is nothing to return to, so end the trip.
        if (_pedestrianPromptOnArrival) {
          await _finishNavigation();
          if (mounted) {
            await _endTripAndShowHome();
          }
        }
      }
      return;
    } finally {
      routesSubscription.close();
    }

    // Navigate to new navigation session
    if (mounted) {
      try {
        // Start navigation on the newly calculated route
        await dgisController.startNavigation(NavigationConstants.navigationSpeedRangeZooms);

        final startedState = await dgisController.getCurrentNavigationState();

        // Save the navigation state so it can be restored on the new page
        final state = await dgisController.saveNavigationState();
        await ref.read(sharedPrefsProvider).setString(MapnessConstants.navigatorStateKey, base64.encode(state));
        await ref
            .read(sharedPrefsProvider)
            .setString(MapnessConstants.navigatorStateTypeKey, RouteSearchOptionsMessage.pedestrian.name);
      } catch (e) {
        logger.log(
          'PathNavPage: failed to start pedestrian navigation: $e',
          logLevel: MapnessLogLevel.error,
        );
        if (mounted) {
          _showPedestrianSwitchError(e);
          isSwitchingToFoot.value = false;
          _isSwitchingToPedestrian = false;
          _pedestrianSwitchInProgress = false;
          await _finishNavigation();
          if (mounted) {
            await _endTripAndShowHome();
          }
        }
        return;
      }

      // Avoid pre-replace zoom to reduce flicker; we will adjust after restore

      // Replace current page with pedestrian navigation
      // Set to false before navigating to avoid keeping the overlay if something goes wrong during replacement
      isSwitchingToFoot.value = false;
      _isSwitchingToPedestrian = false;
      _pedestrianSwitchInProgress = false;
      await context.router.popAndPush(
        PathNavRoute(
          navType: RouteSearchOptionsMessage.pedestrian,
          isHomeOrWork: widget.isHomeOrWork,
          initAction: PathNavPageInitAction.restoreFromState,
        ),
      );
      return;
    }
  }

  void _showPedestrianSwitchError(Object error) {
    final toastCtx = rootNavigatorKey.currentContext ?? context;
    if (!toastCtx.mounted) {
      return;
    }
    final message = switch (error) {
      NoInternetException() => toastCtx.l10n.noInternetConnection,
      WalkingDistanceException() => toastCtx.l10n.walkingDistanceTooLong,
      _ => toastCtx.l10n.routeNotFound,
    };
    ToastOverlay.of(toastCtx).show(title: message);
  }

  /// Called both when the user closes the prompt and when it auto-dismisses (TP-07).
  Future<void> onCancelSwitchToPedestrian() async {
    if (_pedestrianSwitchInProgress) {
      // The user already accepted the switch — a late countdown callback must not end the trip.
      return;
    }
    _pedestrianPromptDismissedAt = DateTime.now();
    isSwitchingToFoot.value = false;
    setState(() {
      _showPedestrianPrompt = false;
    });

    if (!_pedestrianPromptOnArrival) {
      // Dismissed while still driving — the car navigation keeps running and the
      // prompt may reappear after the re-display interval (TP-05, TP-06).
      return;
    }

    _isSwitchingToPedestrian = false;
    await _finishNavigation();
    if (mounted) {
      await _endTripAndShowHome();
    }
  }

  Future<void> _moveCameraToUser({bool followAfter = true}) async {
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

    // HB-23: the camera is positioned BEFORE follow is switched on, and nothing
    // touches it afterwards. An explicit animateTo after startFollowNavigation
    // counts as manual camera interaction for the SDK, so the follow controller
    // stepped aside for its followReturnDelay (15s) and the camera sat facing
    // north — never swinging in behind the car — until that delay ran out.
    if (followAfter) {
      await dgisController.startFollowNavigation();
    }
  }

  /// Checks if the distance between current position and route start point is reasonable
  bool _isLocationAccuracyAcceptable(double latitude, double longitude) {
    final routeStartPoint = ref.read(etaRouteInfoProvider).startPoint;
    final startLat = routeStartPoint?.lat;
    final startLon = routeStartPoint?.lon;
    // A start point without coordinates says nothing about accuracy, so it is
    // treated like having no start point at all rather than as a failure.
    if (startLat != null && startLon != null) {
      final distance = CommonFunctions.calculateDistance(latitude, longitude, startLat, startLon);

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
