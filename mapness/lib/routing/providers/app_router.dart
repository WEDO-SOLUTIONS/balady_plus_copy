import 'package:flutter/material.dart';
import 'package:mapness/features/profile/profile_page.dart';
import 'package:mapness/features/favourites/favourites.dart';
import 'package:mapness/features/favourites/favourites_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing/landing_page.dart';
import '../scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final _routeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'route');
final _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final _favouritesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'favourites');
// final _favouritesSearchNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'favouritesSearch');

enum AppRoute {
  map,
  route,
  cart,
  dashboard,
  profile,
  favourites,
  favouritesSearch,
  favouritesSearchResult,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref, List<Widget> routes) {
  return GoRouter(
    initialLocation: '/landing',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          if (state.fullPath == "/profile") {
            return navigationShell;
          }

          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            // navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.map.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/services',
                name: AppRoute.route.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: routes[1],
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: _routeNavigatorKey,
            routes: [
              GoRoute(
                path: '/routing',
                name: AppRoute.dashboard.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SizedBox.shrink(),
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: _mapNavigatorKey,
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
      // StatefulShellBranch(
      //     navigatorKey: _favouritesNavigatorKey,
      //     routes: [
      GoRoute(
        path: '/favourites',
        name: AppRoute.favourites.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Favourites(),
        ),
        routes: [
          GoRoute(
            path: 'search',
            parentNavigatorKey: _rootNavigatorKey,
            name: AppRoute.favouritesSearch.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavouritesSearch(),
            ),
            routes: const [],
          ),
        ],
      ),
    ],
  );
}
