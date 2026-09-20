import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/top_route_name_notifier.dart';

const _explicitNaviRoutes = _RouteConfig(
  currentRoutes: {PathNavRoute.name},
  upcomingRoutes: {
    RoutingRoutesRoute.name,
    PoiCardWidgetRoute.name,
  },
);

const _implicitNaviRoutes = _RouteConfig(
  currentRoutes: {RoutingRoutesRoute.name},
  upcomingRoutes: {
    RoutingRoutesRoute.name,
    PoiCardWidgetRoute.name,
  },
);

/// shows confirmation botton sheet if navigation is currently active or hide routes silently
final class NavigationGuard extends AutoRouteGuard {
  final Ref ref;

  const NavigationGuard(this.ref);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_explicitNaviRoutes.routeMatches(resolver, router)) {
      // One question at a time. Every blocked navigation attempt used to push
      // its own sheet, and during a drive they arrive in bursts — a tap lands
      // while the previous sheet is still animating in, or several map objects
      // sit under one finger — so the player ended up dismissing a stack of
      // identical "Exit current navigation?" sheets, each with its own pending
      // resolver and its own 4-second auto-cancel. Later attempts are simply
      // refused while one is open; the sheet already on screen speaks for them.
      if (router.stack.any((entry) => entry.name == ExitNavigationRoute.name)) {
        resolver.next(false);
        return;
      }
      // stop navigation after user confirmation
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
    } else if (_implicitNaviRoutes.routeMatches(resolver, router)) {
      // hide routes silently
      await ref.read(dgisControllerProvider).value?.hideRoutes();
      resolver.next();
    } else {
      resolver.next();
    }
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

class _RouteConfig extends Equatable {
  final Set<String> currentRoutes;
  final Set<String> upcomingRoutes;

  const _RouteConfig({required this.currentRoutes, required this.upcomingRoutes});

  @override
  List<Object?> get props => [currentRoutes, upcomingRoutes];

  bool routeMatches(NavigationResolver resolver, StackRouter router) {
    final nextRoute = resolver.route.name;
    final hasOpenedRoutes = router.stack.any((e) => currentRoutes.contains(e.name));
    return hasOpenedRoutes && upcomingRoutes.contains(nextRoute);
  }
}
