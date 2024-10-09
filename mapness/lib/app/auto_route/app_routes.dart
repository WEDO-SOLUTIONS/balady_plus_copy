import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/others/onboard_route_guard.dart';
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
          path: '/',
          page: MapRoute.page,
          children: [
            CustomRoute(
              path: 'kiblah',
              page: KiblahRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn
            ),
            CustomRoute(
              page: BottomMenuRoute.page,
              initial: true,
              guards: [
                OnboardRouteGuard(ref),
              ],
              children: [
                CustomRoute(
                  path: 'explore',
                  page: LandingRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'routing',
                  page: RoutingPointsRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'services',
                  page: MapnessServicesRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'profile',
                  page: ProfileRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
              ],
            ),
          ],
        ),
      ];
}
