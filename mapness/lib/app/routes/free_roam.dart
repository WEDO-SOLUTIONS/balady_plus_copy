import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/free_roam/free_roam_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'free_roam.g.dart';

@TypedGoRoute<FreeRoamRoute>(
  path: FreeRoamRoute.path,
)
class FreeRoamRoute extends GoRouteData {
  static const path = '/freeRoam';
  const FreeRoamRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _freeRoamTransition(
        context: context,
        child: const FreeRoamPage(),
      );

  static void open(GoRouter router) {
    const route = FreeRoamRoute();
    final location = route.location;

    router.go(location);
  }
}

TransculentPage<void> _freeRoamTransition({
  required BuildContext context,
  required Widget child,
}) =>
    TransculentPage(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    );

final $freeRoamRoutes = $appRoutes;
