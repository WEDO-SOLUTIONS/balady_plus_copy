import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart' hide $appRoutes;
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/pages/routing/routing_favourites.dart';
import 'package:mapness/pages/routing/routing_map_select.dart';
import 'package:mapness/pages/routing/routing_routes.dart';
import 'package:mapness/pages/routing/routing_search.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'routing.g.dart';

@TypedGoRoute<RoutingSearchRoute>(
  path: '/routingSearch',
)
class RoutingSearchRoute extends GoRouteData {
  const RoutingSearchRoute({
    required this.placeholder,
    required this.showMyLocation,
    this.initialQuery,
  });

  final String? initialQuery;
  final String placeholder;
  final bool showMyLocation;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: RoutingSearchSheet(
          placeholder: placeholder,
          showMyLocation: showMyLocation,
          initialQuery: initialQuery,
        ),
      );
}

@TypedGoRoute<RoutingMapRoute>(
  path: '/routingMap',
)
class RoutingMapRoute extends GoRouteData {
  const RoutingMapRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const TransculentPage(
        child: RoutingMapSelect(),
      );
}

@TypedGoRoute<RoutingFavouritesRoute>(
  path: '/routingFavourites',
)
class RoutingFavouritesRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const TransculentPage(
        child: RoutingFavouritesPage(),
      );
}

@TypedGoRoute<RoutingRoutesRoute>(
  path: '/routingRoutes',
)
class RoutingRoutesRoute extends GoRouteData {
  const RoutingRoutesRoute({
    required this.startLatitude,
    required this.startLongitude,
    required this.startLabel,
    required this.finishLatitude,
    required this.finishLongitude,
    required this.finishLabel,
  });

  final double? startLatitude;
  final double? startLongitude;
  final String startLabel;
  final double? finishLatitude;
  final double? finishLongitude;
  final String finishLabel;

  RouteParamsPoint? get startPoint {
    if (startLatitude != null && startLongitude != null) {
      return RouteParamsPoint(
        latitude: startLatitude!,
        longitude: startLongitude!,
      );
    }

    return null;
  }

  RouteParamsPoint? get finishPoint {
    if (finishLatitude != null && finishLongitude != null) {
      return RouteParamsPoint(
        latitude: finishLatitude!,
        longitude: finishLongitude!,
      );
    }

    return null;
  }

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: RoutingRoutesPage(
          points: [
            startPoint,
            finishPoint,
          ],
          labels: [
            startLabel,
            finishLabel,
          ],
        ),
      );
}

final $routingRoutes = $appRoutes;
