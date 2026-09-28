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
  });

  /// [route] is the trip route without the stops already passed.
  factory AddStopPrompt.forPoi({
    required int objectId,
    required RouteSearchOptionsMessage navType,
    required CurrentRouteState? route,
  }) => AddStopPrompt(
    navType: navType,
    tripSource: route?.tripSource ?? NavigationTripSource.phone,
    stopsCount: route?.stopsCount ?? 0,
    limitReached: (route?.stopsCount ?? 0) >= maxIntermediateStops,
    poiInRoute: route?.containsPOI(objectId) ?? false,
    routeKnown: route != null,
  );

  final RouteSearchOptionsMessage navType;
  final NavigationTripSource tripSource;
  final int stopsCount;
  final bool limitReached;
  final bool poiInRoute;
  final bool routeKnown;

  /// A POI already on the route (stop or finish) gets no "Add stop" at all.
  bool get showAddStop => routeKnown && !poiInRoute;

  bool get canAddStop => showAddStop && !limitReached;
}
