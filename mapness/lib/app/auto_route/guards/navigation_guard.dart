import 'package:auto_route/auto_route.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';

const _routesToSkip = {
  RoutingRoutesRoute.name,
  PoiCardWidgetRoute.name,
};

const _naviRoutes = {
  PathNavRoute.name,
};

/// shows confirmation botton sheet if navigation is currently active
final class NavigationGuard extends AutoRouteGuard {
  const NavigationGuard();

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final nextRoute = resolver.route.name;
    final hasOpenedNavigationRoutes = router.stack.any((e) => _naviRoutes.contains(e.name));
    if (hasOpenedNavigationRoutes && _routesToSkip.contains(nextRoute)) {
      router.push(
        ExitNavigationRoute(
          onConfirm: () {
            resolver.next();
          },
          onCancel: () {
            resolver.next(false);
          },
        ),
      );
      return;
    }
    resolver.next();
  }
}
