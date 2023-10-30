import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing/landing_page.dart';
import '../scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final _routeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'route');
final _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

enum AppRoute {
  map,
  route,
  cart,
  dashboard,
  profile,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref, List<Widget> routes) {
  return GoRouter(
    initialLocation: '/landing',
    // navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _mapNavigatorKey,
            routes: [
              GoRoute(
                path: '/map',
                name: AppRoute.map.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: routes[0],
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _routeNavigatorKey,
            routes: [
              GoRoute(
                path: '/route',
                name: AppRoute.route.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: routes[1],
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: AppRoute.dashboard.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: routes[2],
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/landing',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: LandingPage(),
                ),
                routes: const [],
              ),
            ],
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
