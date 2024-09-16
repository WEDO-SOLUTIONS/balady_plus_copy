import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/pages/dark_map_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'dark_map.g.dart';

@TypedGoRoute<DarkMapRoute>(
  path: DarkMapRoute.path,
)
class DarkMapRoute extends GoRouteData {
  static const path = '/dark_map';

  const DarkMapRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TransculentPage(
        child: DarkMapPage(),
      );
}

final $darkMapRoutes = $appRoutes;
