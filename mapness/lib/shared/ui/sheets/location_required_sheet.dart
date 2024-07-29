import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';
import 'package:mapness/shared/ui/location/location_error_sheet.dart';

part 'location_required_sheet.g.dart';

@TypedGoRoute<LocationErrorSheetRoute>(
  path: LocationErrorSheetRoute.path,
)
class LocationErrorSheetRoute extends GoRouteData {
  static const path = '/location_error_sheet_route';

  const LocationErrorSheetRoute({this.routeOnClose});
  final String? routeOnClose;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
      child: LocationErrorSheet(routeOnClose: routeOnClose)
    );
}

final $locationErrorBoundaryRoute = $appRoutes;
