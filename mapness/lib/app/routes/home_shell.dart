import 'package:balady_plus/app/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/landing_page.dart';
import 'package:mapness/_features/profile/pages/profile_page.dart';
import 'package:mapness/pages/routing/routing_points.dart';
import 'package:mapness/shared/providers/app_language.dart';
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
          path: RoutingRoute.path,
        ),
      ],
    ),
    TypedStatefulShellBranch<LandingBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<LandingRoute>(
          path: LandingRoute.path,
        ),
      ],
    ),
  ],
)
class HomeShellRoute extends StatefulShellRouteData {
  const HomeShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      TransculentPage(
        child: ScaffoldWithNestedNavigation(
          navigationShell: navigationShell,
        ),
      );
}

class LandingBranch extends StatefulShellBranchData {
  const LandingBranch();
}

class LandingRoute extends GoRouteData {
  static const path = '/landing';

  const LandingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(child: LandingPage());
}

class RoutingBranch extends StatefulShellBranchData {
  const RoutingBranch();
}

class RoutingRoute extends GoRouteData {
  static const path = '/routing';

  const RoutingRoute({this.collapseInitially = false});

  /// open page with collapsed bottom sheet
  final bool collapseInitially;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: RoutingPointsPage(
          collapseInitially: collapseInitially,
        ),
      );
}

class ServicesBranch extends StatefulShellBranchData {
  const ServicesBranch();
}

class ServicesRoute extends GoRouteData {
  const ServicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Consumer(
        builder: (context, ref, child) {
          final language = ref.watch(appLanguageProvider);
          return Directionality(
            textDirection: switch (language) {
              Language.english => TextDirection.ltr,
              Language.arabic => TextDirection.rtl,
            },
            child: const ServicesPage(),
          );
        },
      );
}

class ProfilesBranch extends StatefulShellBranchData {
  const ProfilesBranch();
}

class ProfilesRoute extends GoRouteData {
  const ProfilesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfilePage();
}

RouteBase homeShellRoute({required bool naviEnabled}) => StatefulShellRouteData.$route(
      factory: $HomeShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/profile',
              factory: $ProfilesRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/services',
              factory: $ServicesRouteExtension._fromState,
            ),
          ],
        ),
        if (naviEnabled)
          StatefulShellBranchData.$branch(
            routes: [
              GoRouteData.$route(
                path: RoutingRoute.path,
                factory: $RoutingRouteExtension._fromState,
              ),
            ],
          ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: LandingRoute.path,
              factory: $LandingRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );
