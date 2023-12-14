import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/pages/kiblah/kiblah_page.dart';
import 'package:mapness/app/routes/routes.dart';

part 'kiblah.g.dart';

@TypedGoRoute<KiblahRoute>(
  path: '/kiblah',
)
class KiblahRoute extends GoRouteData {
  const KiblahRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      fullscreenDialog: true,
      opaque: false,
      transitionsBuilder: (_, __, ___, child) => child,
      child: const KiblahPage(),
    );
  }
}

final $kiblahRoutes = $appRoutes;
