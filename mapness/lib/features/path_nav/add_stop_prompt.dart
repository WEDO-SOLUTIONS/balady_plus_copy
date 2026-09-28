import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/routing/providers/current_route.dart';

/// What the add-stop sheet offers for a POI tapped during guidance.
@immutable
class AddStopPrompt {
  const AddStopPrompt({
    required this.navType,
    required this.tripSource,
    required this.stopsCount,
    required this.limitReached,
    required this.poiInRoute,
    required this.routeKnown,
    this.route,
  });

  /// [route] is the trip route without the stops already passed; [position] is where the POI was tapped.
  factory AddStopPrompt.forPoi({
    required int objectId,
    required LatLng position,
    required RouteSearchOptionsMessage navType,
    required CurrentRouteState? route,
  }) => AddStopPrompt(
    navType: navType,
    tripSource: route?.tripSource ?? NavigationTripSource.phone,
    stopsCount: route?.stopsCount ?? 0,
    limitReached: (route?.stopsCount ?? 0) >= maxIntermediateStops,
    poiInRoute:
        (route?.containsPOI(objectId) ?? false) ||
        (route?.hasPointWithoutObjectNear(latitude: position.latitude, longitude: position.longitude) ?? false),
    routeKnown: route != null,
    route: route,
  );

  final RouteSearchOptionsMessage navType;
  final NavigationTripSource tripSource;
  final int stopsCount;
  final bool limitReached;
  final bool poiInRoute;

  /// False while the route of a trip started outside Flutter is not rebuilt yet.
  final bool routeKnown;
  final CurrentRouteState? route;

  /// A POI already on the route (stop or finish) gets no "Add stop" at all.
  bool get showAddStop => !poiInRoute;

  bool get canAddStop => routeKnown && showAddStop && !limitReached;

  /// The POI position from the directory can reveal a coordinate-only route point missed by the tap point.
  AddStopPrompt withPoiPosition(GeoPointWithElevationMessage? position) {
    final isRoutePoint =
        position != null &&
        (route?.hasPointWithoutObjectNear(latitude: position.latitude, longitude: position.longitude) ?? false);
    return poiInRoute || !isRoutePoint
        ? this
        : AddStopPrompt(
            navType: navType,
            tripSource: tripSource,
            stopsCount: stopsCount,
            limitReached: limitReached,
            poiInRoute: true,
            routeKnown: routeKnown,
            route: route,
          );
  }
}
