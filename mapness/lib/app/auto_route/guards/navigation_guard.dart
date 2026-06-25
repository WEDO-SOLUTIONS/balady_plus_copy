import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/top_route_name_notifier.dart';

const _routesToSkip = {
  RoutingRoutesRoute.name,
  PoiCardWidgetRoute.name,
};

const _naviRoutes = {
  PathNavRoute.name,
};

/// shows confirmation botton sheet if navigation is currently active
final class NavigationGuard extends AutoRouteGuard {
  final Ref ref;

  const NavigationGuard(this.ref);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final nextRoute = resolver.route.name;
    final hasOpenedNavigationRoutes = router.stack.any((e) => _naviRoutes.contains(e.name));
    if (hasOpenedNavigationRoutes && _routesToSkip.contains(nextRoute)) {
      router.push(
        ExitNavigationRoute(
          onConfirm: () async {
            await ref.read(dgisControllerProvider).value?.stopNavigation();
            // wait for navigation to really stop. The page won't open otherwise
            await _waitForRoute(router, BottomMenuRoute.name);
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

  Future<void> _waitForRoute(RoutingController router, String routeName) {
    final completer = Completer<void>();
    final subscription = ref.listen(
      topRouteNameProvider,
      (_, next) {
        final topRouteName = next.value;
        if (topRouteName == routeName) {
          completer.complete();
        }
      },
    );

    return completer.future
        .onError((error, stackTrace) => null)
        .timeout(const Duration(seconds: 1), onTimeout: () => null)
        .then((_) => subscription.close());
  }
}
