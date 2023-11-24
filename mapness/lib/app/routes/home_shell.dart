import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/landing_page.dart';
import 'package:mapness/_features/profile/profile_page.dart';
import 'package:mapness/pages/routing/routing_points.dart';
import 'package:mapness/shared/routing/scaffold_with_nested_navigation.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'home_shell.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<HomeShellRoute>(
  branches: [
    TypedStatefulShellBranch<ProfilesBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ProfilesRoute>(
          path: '/profile',
        ),
      ],
    ),
    TypedStatefulShellBranch<ServicesBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ServicesRoute>(
          path: '/services',
        ),
      ],
    ),
    TypedStatefulShellBranch<RoutingBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<RoutingRoute>(
          path: '/routing',
        ),
      ],
    ),
    TypedStatefulShellBranch<LandingBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<LandingRoute>(
          path: '/landing',
        ),
      ],
    ),
  ],
)
class HomeShellRoute extends StatefulShellRouteData {
  const HomeShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Page<void> pageBuilder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) {
    if (state.fullPath == "/profile") {
      return TransculentPage(child: navigationShell);
    }

    return TransculentPage(
      child: ScaffoldWithNestedNavigation(
        navigationShell: navigationShell,
      ),
    );
  }
}

class LandingBranch extends StatefulShellBranchData {
  const LandingBranch();
}

class LandingRoute extends GoRouteData {
  const LandingRoute();

  @override
  Page<void> buildPage(context, state) => const TransculentPage(
        child: LandingPage(),
      );
}

class RoutingBranch extends StatefulShellBranchData {
  const RoutingBranch();
}

class RoutingRoute extends GoRouteData {
  const RoutingRoute();

  @override
  Page<void> buildPage(context, state) => const TransculentPage(
        child: RoutingPointsPage(),
      );
}

class ServicesBranch extends StatefulShellBranchData {
  const ServicesBranch();
}

class ServicesRoute extends GoRouteData {
  const ServicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SizedBox.shrink();
}

class ProfilesBranch extends StatefulShellBranchData {
  const ProfilesBranch();
}

class ProfilesRoute extends GoRouteData {
  const ProfilesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

final $homeRoutes = $appRoutes;
