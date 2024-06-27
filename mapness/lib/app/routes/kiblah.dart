import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/kiblah/kiblah_page.dart';

part 'kiblah.g.dart';

@TypedGoRoute<KiblahRoute>(
  path: KiblahRoute.path,
)
class KiblahRoute extends GoRouteData {
  static const path = '/kiblah';

  const KiblahRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        transitionsBuilder: (_, __, ___, child) => child,
        child: const KiblahPage(),
      );
}

final $kiblahRoutes = $appRoutes;
