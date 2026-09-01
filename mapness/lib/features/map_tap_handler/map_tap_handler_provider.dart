import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart' hide RoadEventType, RoadEventLane, RoadEventActionType, RoadEventTapEvent;
import 'package:flutter/foundation.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
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

  void handleTap(RoadEvent event) {
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.roadEvent,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'event': event.id, 'type': event.type},
    );
    final nextState = RoadEventSheetState.fromDomain(event);
    final router = ref.read(appRouterProvider);

    if (router.topRoute.name == RoadEventDetailsRoute.name) {
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
        RoadEventDetailsRoute(
          id: nextState.id,
          location: nextState.location,
          createdAt: nextState.createdAt,
          expiresAt: nextState.expiresAt,
          type: nextState.type,
          lanes: nextState.lanes,
          feedback: nextState.feedback,
          updatedAt: nextState.updatedAt,
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
        RoadEventDetailsRoute.name =>
          currentState ?? RoadEventSheetState.fromRouteArgs(router.topRoute.argsAs<RoadEventDetailsRouteArgs>()),
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

    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.map,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'objectId': event.dgisObjectId.objectId},
    );

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

  void _handleMyLocationTapEvent(MyLocationTapEvent event) {
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

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
    required this.location,
    required this.createdAt,
    required this.expiresAt,
    required this.type,
    required this.lanes,
    required this.feedback,
    required this.updatedAt,
  });

  factory RoadEventSheetState.fromDomain(RoadEvent event) => RoadEventSheetState(
    id: event.id,
    location: event.location,
    createdAt: event.createdAt,
    expiresAt: event.expiresAt,
    type: event.type,
    lanes: event.lanes,
    feedback: event.feedback,
    updatedAt: event.updatedAt,
  );

  factory RoadEventSheetState.fromRouteArgs(RoadEventDetailsRouteArgs args) => RoadEventSheetState(
    id: args.id,
    location: args.location,
    createdAt: args.createdAt,
    expiresAt: args.expiresAt,
    type: args.type,
    lanes: args.lanes,
    feedback: args.feedback,
    updatedAt: args.updatedAt,
  );

  final String id;
  final RoadEventLocation location;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final RoadEventType? type;
  final Set<RoadEventLane> lanes;
  final RoadEventFeedback feedback;
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoadEventSheetState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt &&
          type == other.type &&
          updatedAt == other.updatedAt &&
          const SetEquality<RoadEventLane>().equals(lanes, other.lanes) &&
          const SetEquality<RoadEventActionType>().equals(
            feedback.availableActionTypes,
            other.feedback.availableActionTypes,
          );

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    expiresAt,
    type,
    updatedAt,
    Object.hashAllUnordered(lanes),
    Object.hashAllUnordered(feedback.availableActionTypes),
  );
}
