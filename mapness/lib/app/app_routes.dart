import 'package:auto_route/auto_route.dart';

import 'app_routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: BottomMenuRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: LandingRoute.page,
            ),
            AutoRoute(
              page: RoutingPointsRoute.page,
            ),
            AutoRoute(
              page: MapnessServicesRoute.page,
            ),
            AutoRoute(
              page: ProfileRoute.page,
            ),
          ],
        )
      ];
}
