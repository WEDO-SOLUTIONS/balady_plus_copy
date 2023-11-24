import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'path_nav.g.dart';

@TypedGoRoute<PathNavRoute>(
  path: '/pathNav',
  // routes: <TypedGoRoute<GoRouteData>>[],
)
class PathNavRoute extends GoRouteData {
  const PathNavRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _pathNavTransition(context: context, child: const PathNavPage());
  }
}

TransculentPage<void> _pathNavTransition({
  required BuildContext context,
  required Widget child,
}) =>
    TransculentPage(
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Align(alignment: Alignment.bottomCenter, child: child),
        ),
      ),
    );

final $pathNavRoutes = $appRoutes;
