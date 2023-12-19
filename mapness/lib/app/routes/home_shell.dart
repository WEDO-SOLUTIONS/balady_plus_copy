import 'package:balady_plus/app/features/services/presentation/pages/services_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/landing_page.dart';
import 'package:mapness/_features/profile/profile_page.dart';
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
  final LangingFocusMaker? focusMaker;

  const LandingRoute({this.focusMaker});

  @override
  Page<void> buildPage(context, state) => TransculentPage(
        child: LandingPage(
          focusMaker: focusMaker ??
              LangingFocusMaker.values.firstWhereOrNull(
                (element) =>
                    element.name == state.uri.queryParameters['focus-maker'],
              ),
        ),
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
  Widget build(BuildContext context, GoRouterState state) {
    return Consumer(
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

RouteBase homeShellRoute({required bool naviEnabled}) =>
    StatefulShellRouteData.$route(
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
                path: '/routing',
                factory: $RoutingRouteExtension._fromState,
              ),
            ],
          ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/landing',
              factory: $LandingRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );
