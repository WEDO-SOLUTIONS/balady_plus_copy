import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/onboard_route_guard.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

import 'app_routes.gr.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref));

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final ProviderRef ref;

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: OnboardRoute.page,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.onboarding,
            child: child,
          ),
        ),
        CustomRoute(
          page: StoriesRoute.page,
          opaque: false,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.network,
            child: child,
          ),
        ),
        AutoRoute(
          page: BottomMenuRoute.page,
          guards: [
            OnboardRouteGuard(ref),
          ],
          initial: true,
          children: [
            AutoRoute(
              page: landingShell.page,
              children: [
                AutoRoute(page: LandingRoute.page),
              ],
            ),
            AutoRoute(page: RoutingPointsRoute.page),
            AutoRoute(page: MapnessServicesRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}

const landingShell = EmptyShellRoute('Landing');
