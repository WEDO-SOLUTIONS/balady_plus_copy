import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_sheet.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_tap_handler_provider.g.dart';
part 'map_tap_mixin.dart';

typedef OnMapTapHandler = void Function(TapEvent event);

@Riverpod(keepAlive: true)
class RoadEvents extends _$RoadEvents {
  @override
  RoadEventSheetState? build() {
    final appRouter = ref.read(appRouterProvider);
    final removeRouterListener = appRouter.removeListener;

    appRouter.addListener(_onAppRouterChanged);
    ref.onDispose(() {
      removeRouterListener(_onAppRouterChanged);
    });

    return _routeState(appRouter, currentState: null);
  }

  void handleTap(RoadEventTapEvent event) {
    final nextState = RoadEventSheetState.fromEvent(event);
    final router = ref.read(appRouterProvider);

    if (router.topRoute.name == RoadClosedRoute.name) {
      if (state == nextState) {
        return;
      }
      state = nextState;
      return;
    }

    state = nextState;

    // BSA-2431: We don't need description here, we don't use it according to the design
    // If we will need it, we can add it in the future
    unawaited(
      router.push(
        RoadClosedRoute(
          id: nextState.id,
          title: nextState.title,
          startTime: nextState.startTime,
          finishTime: nextState.finishTime,
        ),
      ),
    );
  }

  void _onAppRouterChanged() {
    final router = ref.read(appRouterProvider);
    final nextState = _routeState(router, currentState: state);

    if (state != nextState) {
      state = nextState;
    }
  }

  RoadEventSheetState? _routeState(AppRouter router, {required RoadEventSheetState? currentState}) =>
      switch (router.topRoute.name) {
        RoadClosedRoute.name =>
          currentState ?? RoadEventSheetState.fromRouteArgs(router.topRoute.argsAs<RoadClosedRouteArgs>()),
        _ => null,
      };
}

@riverpod
class MapTapHandler extends _$MapTapHandler with GuardTapEventMixin {
  StreamSubscription<TapEvent>? _baseStreamSubscription;
  ProviderSubscription<RoadEventSheetState?>? _poiPageClosingSubscription;

  OnMapTapHandler? _priorityMapTapHandler;

  int _pendingMakkahSuppression = 0;
  Timer? _pendingMakkahSuppressionTimer;
  static const Duration _makkahTapSuppressionWindow = Duration(milliseconds: 400);

  late final StreamController<TapEvent> _currentMapHandlers = StreamController.broadcast();

  @override
  Future<void> build() async {
    final dgisController = await ref.watch(dgisControllerProvider.future);

    _baseStreamSubscription = dgisController.objectTapEvents.listen(_onNewEvent);
    _poiPageClosingSubscription = ref.listen<RoadEventSheetState?>(roadEventsProvider, (previous, next) {
      if (previous != null && next == null) {
        unawaited(ref.read(selectedMarkerProvider.notifier).clear());
      }
    });

    ref.onDispose(() {
      _baseStreamSubscription?.cancel();
      _poiPageClosingSubscription?.close();
      _pendingMakkahSuppressionTimer?.cancel();
      _clearTapDisableOwners();
      _currentMapHandlers.close();
    });
  }

  /// Sets a high-priority tap handler that will be called before the default one.
  // ignore: avoid_setters_without_getters
  set priorityMapTapHandler(OnMapTapHandler handler) => _priorityMapTapHandler = handler;

  /// Resets the previously set priority map tap handler, reverting to default behavior.
  void resetPriorityMapTapHandler() {
    _priorityMapTapHandler = null;
  }

  void notifyMakkahMarkerTapped() {
    _pendingMakkahSuppression = 2;
    _pendingMakkahSuppressionTimer?.cancel();
    _pendingMakkahSuppressionTimer = Timer(_makkahTapSuppressionWindow, () {
      _pendingMakkahSuppression = 0;
      _pendingMakkahSuppressionTimer = null;
    });
  }

  /// Registers a callback to handle tap events on the map.
  StreamSubscription<TapEvent> listen(OnMapTapHandler handler) => _currentMapHandlers.stream.listen(handler);

  /// Handles all incoming tap events, passing them to the priority handler or the default one.
  void _onNewEvent(TapEvent event) {
    /// If the tap handler is disabled, do not process the event.
    if (isDisabledTapHandler) {
      return;
    }

    if (_priorityMapTapHandler != null) {
      _priorityMapTapHandler!(event);
    } else {
      _guardDefaultTap(() => _defaultOnMapClickListener(event));
    }
    _currentMapHandlers.sink.add(event);
  }

  /// Processes map tap events if no priority handler is set,
  /// including navigation and metrics logging.
  ///
  /// Default tap handler just manages the tap events and navigates to the corresponding screens.
  /// The logic of protection of unnecessary taps is implemented in the mixin.
  void _defaultOnMapClickListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      _handleObjectTapEvent(event);
    } else if (event is RoadEventTapEvent) {
      _handleRoadEventTapEvent(event);
    } else if (event is MyLocationTapEvent) {
      _handleMyLocationTapEvent(event);
    }
  }

  void _handleObjectTapEvent(ObjectTapEvent event) {
    if (_consumePendingMakkahSuppression()) {
      return;
    }

    // DataFinder: a POI tapped directly on the map starts a "Map" journey
    // (BRD `Map-Main Page`). Carried through Directions → Go → Search → favorite.
    ref.read(dataFinderSourceTrackerProvider.notifier).stampOrigin(DataFinderOrigin.map);

    ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(objectId: event.dgisObjectId.objectId, entranceId: 0),
            closestPoint: event.latLng,
          ),
          toCompareRoutes: [ShareMyLocationRoute.page, PoiCardWidgetRoute.page, HajjPoiCardRoute.page],
        );
  }

  bool _consumePendingMakkahSuppression() {
    if (_pendingMakkahSuppression <= 0) {
      return false;
    }
    _pendingMakkahSuppression--;
    if (_pendingMakkahSuppression == 0) {
      _pendingMakkahSuppressionTimer?.cancel();
      _pendingMakkahSuppressionTimer = null;
    }
    return true;
  }

  void _handleRoadEventTapEvent(RoadEventTapEvent event) {
    ref.read(roadEventsProvider.notifier).handleTap(event);
  }

  void _handleMyLocationTapEvent(MyLocationTapEvent event) {
    // BALADY-3764: during turn-by-turn guidance and free roam the
    // my-location object is the 3D navigation cursor. Tapping it opens
    // Navigator Customization (Figma 2287-3140) as a bottom sheet so the
    // driver keeps the route context; the share-location card remains the
    // behaviour everywhere else.
    final router = ref.read(appRouterProvider);
    final topRouteName = router.topRoute.name;
    if (topRouteName == PathNavRoute.name || topRouteName == FreeRoamRoute.name) {
      final sheetContext = rootNavigatorKey.currentContext;
      if (sheetContext != null) {
        unawaited(showCursorsSheet(sheetContext));
      }
      return;
    }

    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final userLocation = ref.read(locationProvider);

    ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: ShareMyLocationRoute(
            cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
            closestPoint: userLocation != null
                ? LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude)
                : event.latLng,
          ),
          toCompareRoutes: [ShareMyLocationRoute.page, PoiCardWidgetRoute.page, HajjPoiCardRoute.page],
        );
  }
}

@immutable
class RoadEventSheetState {
  const RoadEventSheetState({
    required this.id,
    required this.title,
    required this.objectId,
    required this.startTime,
    required this.finishTime,
  });

  factory RoadEventSheetState.fromEvent(RoadEventTapEvent event) => RoadEventSheetState(
    id: event.id,
    title: event.title,
    objectId: event.id.objectId,
    startTime: event.startTime,
    finishTime: event.finishTime,
  );

  factory RoadEventSheetState.fromRouteArgs(RoadClosedRouteArgs args) => RoadEventSheetState(
    id: args.id,
    title: args.title,
    objectId: args.id.objectId,
    startTime: args.startTime,
    finishTime: args.finishTime,
  );

  final DgisObjectId id;
  final String title;
  final int objectId;
  final DateTime? startTime;
  final DateTime? finishTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoadEventSheetState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          startTime == other.startTime &&
          finishTime == other.finishTime;

  @override
  int get hashCode => Object.hash(id, title, startTime, finishTime);
}
