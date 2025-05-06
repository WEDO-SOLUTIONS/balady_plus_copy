import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_tap_handler_provider.g.dart';
part 'map_tap_mixin.dart';

typedef OnMapTapHandler = void Function(TapEvent event);

@riverpod
class MapTapHandler extends _$MapTapHandler with GuardTapEventMixin {
  StreamSubscription<TapEvent>? _baseStreamSubscription;

  OnMapTapHandler? _priorityMapTapHandler;

  late final StreamController<TapEvent> _currentMapHandlers = StreamController.broadcast();

  @override
  Future<void> build() async {
    final dgisController = await ref.watch(dgisControllerProvider.future);

    _baseStreamSubscription = dgisController.objectTapEvents.listen(_onNewEvent);

    ref.onDispose(() {
      _baseStreamSubscription?.cancel();
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

  /// Registers a callback to handle tap events on the map.
  StreamSubscription<TapEvent> listen(OnMapTapHandler handler) => _currentMapHandlers.stream.listen(handler);

  /// Handles all incoming tap events, passing them to the priority handler or the default one.
  void _onNewEvent(TapEvent event) {
    /// If the tap handler is disabled, do not process the event.
    if (_isDisabledTapHandler) {
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
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.map,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {
        'objectId': event.dgisObjectId.objectId,
      },
    );

    ref.read(appRouterProvider).replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(
          objectId: event.dgisObjectId.objectId,
          entranceId: 0,
        ),
        closestPoint: event.latLng,
      ),
      toCompareRoutes: [ShareMyLocationRoute.page, PoiCardWidgetRoute.page, RoutingRoutesRoute.page],
    );
  }

  void _handleRoadEventTapEvent(RoadEventTapEvent event) {
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.roadEvent,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'event': event.id.objectId, 'title': event.title},
    );

    final router = ref.read(appRouterProvider);
    final roadClosedRoute = RoadClosedRoute(
      id: event.id,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      finishTime: event.finishTime,
      latitude: event.latLng.latitude,
      longitude: event.latLng.longitude,
    );
    if (router.isRouteActive(RoadClosedRoute.name)) {
      router.popAndPush(
        roadClosedRoute,
      );
    } else {
      router.push(
        roadClosedRoute,
      );
    }
  }

  void _handleMyLocationTapEvent(MyLocationTapEvent event) {
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final userLocation = ref.read(locationProvider);

    ref.read(appRouterProvider).replaceOrPush(
      route: ShareMyLocationRoute(
        cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
        closestPoint: userLocation != null
            ? LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude)
            : event.latLng,
      ),
      toCompareRoutes: [ShareMyLocationRoute.page, PoiCardWidgetRoute.page],
    );
  }
}
