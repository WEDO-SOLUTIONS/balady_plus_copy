import 'package:mapness/features/road_events/data/road_events_datasource.dart';
import 'package:mapness/features/road_events/data/road_events_dio.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/features/road_events/providers/road_events_config.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_events_along_route.g.dart';

/// Road events ahead on the active route, from `POST /events/along-route`.
///
/// Known limitation: the 2GIS SDK bridge only exposes the route's start/
/// intermediate/finish waypoints to Dart (`currentRouteProvider`), not the
/// full driven polyline — so the corridor search here is approximated from
/// those waypoints rather than the actual road geometry. Exposing the real
/// polyline would need new native/pigeon work; out of scope for this
/// migration.
///
/// This provider is currently unconsumed by any UI — a suitable "event(s)
/// ahead" banner in the nav screen (alongside `BetterRouteButton` in
/// `navi_sheet_panel.dart`) is a follow-up once a design exists.
@riverpod
class RoadEventsAlongRoute extends _$RoadEventsAlongRoute {
  @override
  Future<List<RoadEvent>> build() async {
    final routeState = ref.watch(currentRouteProvider);
    if (routeState == null || routeState.points.isEmpty) {
      return const [];
    }

    final waypoints = routeState.points
        .map((p) => p.value)
        .nonNulls
        .map((p) => RoadEventLocation(latitude: p.latitude, longitude: p.longitude))
        .toList();
    if (waypoints.isEmpty) {
      return const [];
    }

    final dio = await ref.watch(roadEventsDioProvider.future);
    final datasource = RoadEventsDatasource(dio: dio);
    final config = await ref.watch(roadEventsConfigProvider.future);
    try {
      return await datasource.fetchAlongRoute(routeGeometry: waypoints, corridorMeters: config.corridorWidthMeters);
    } on Object {
      return const [];
    }
  }
}
