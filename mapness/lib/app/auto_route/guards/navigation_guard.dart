import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/top_route_name_notifier.dart';
import 'package:mapness/shared/utils/detach.dart';

const _destinationRoutes = {
  RoutingRoutesRoute.name,
  PoiCardWidgetRoute.name,
};

const _searchRoutes = {
  NaviSearchRoute.name,
  NaviFavoritesRoute.name,
  SearchRoute.name,
};

const _explicitNaviRoutes = _RouteConfig(
  currentRoutes: {PathNavRoute.name},
  upcomingRoutes: _destinationRoutes,
);

const _implicitNaviRoutes = _RouteConfig(
  currentRoutes: {RoutingRoutesRoute.name},
  upcomingRoutes: _destinationRoutes,
);

/// shows confirmation botton sheet if navigation is currently active or hide routes silently
final class NavigationGuard extends AutoRouteGuard {
  final Ref ref;

  const NavigationGuard(this.ref);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_explicitNaviRoutes.routeMatches(resolver, router)) {
      if (_isDestinationPickedInSearch(resolver, router)) {
        await _stopNavigation(router);
        resolver.next();
        return;
      }
      // stop navigation after user confirmation
      // Not awaited: `push` completes when the sheet is popped, and the guard
      // must return its decision now.
      detach(
        router.push(
          ExitNavigationRoute(
            onConfirm: () async {
              await _stopNavigation(router);
              resolver.next();
            },
            onCancel: () {
              resolver.next(false);
            },
          ),
        ),
        tag: 'navigationGuard.exitNavigation',
      );
    } else if (_implicitNaviRoutes.routeMatches(resolver, router)) {
      // hide routes silently
      await ref.read(dgisControllerProvider).value?.hideRoutes();
      resolver.next();
    } else {
      resolver.next();
    }
  }

  bool _isDestinationPickedInSearch(NavigationResolver resolver, StackRouter router) {
    if (!_destinationRoutes.contains(resolver.route.name)) {
      return false;
    }

    final stack = router.stack;
    final pathNavIndex = stack.lastIndexWhere((e) => e.name == PathNavRoute.name);
    if (pathNavIndex < 0) {
      return false;
    }

    return stack.skip(pathNavIndex + 1).any((e) => _searchRoutes.contains(e.name));
  }

  Future<void> _stopNavigation(RoutingController router) async {
    await ref.read(dgisControllerProvider).value?.stopNavigation();
    await _waitForRoute(router, BottomMenuRoute.name);
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
