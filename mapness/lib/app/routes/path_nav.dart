import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'path_nav.g.dart';

@TypedGoRoute<PathNavRoute>(
  path: PathNavRoute.path,
)
class PathNavRoute extends GoRouteData {
  static const path = '/pathNav';
  static const _extraRouteSearchOptions = 'routeSearchOptions';
  static const _extraInitAction = 'initAction';
  static const _isHomeOrWork = 'isHomeOrWork';

  const PathNavRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    final navType = extra?[_extraRouteSearchOptions] as RouteSearchOptionsMessage;
    final initAction = extra?[_extraInitAction] as PathNavPageInitAction?;
    final isHomeOrWork = extra?[_isHomeOrWork] as bool;
    return _pathNavTransition(
      context: context,
      child: PathNavPage(
        navType: navType,
        initAction: initAction,
        isHomeOrWork: isHomeOrWork,
      ),
    );
  }

  static void open(
    GoRouter router,
    RouteSearchOptionsMessage navType, {
    PathNavPageInitAction? initAction,
    bool isHomeOrWork = false,
  }) {
    const route = PathNavRoute();
    final location = route.location;
    final extra = {
      _extraRouteSearchOptions: navType,
      _extraInitAction: initAction,
      _isHomeOrWork: isHomeOrWork,
    };
    router.push(location, extra: extra);
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
          textDirection: Directionality.of(context),
          child: Align(alignment: Alignment.bottomCenter, child: child),
        ),
      ),
    );

final $pathNavRoutes = $appRoutes;

enum PathNavPageInitAction { startNavigation, restoreFromState }
