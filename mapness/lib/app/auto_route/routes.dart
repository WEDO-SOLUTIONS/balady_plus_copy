import 'package:auto_route/auto_route.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';

class Routes {
  static AutoRoute get bottomMenuRoute => AppRoute(
        path: '',
        page: BottomMenuRoute.page,
        initial: true,
        barrierDismissible: false,
        children: [
          CustomRoute(
            path: 'landing',
            initial: true,
            page: LandingRoute.page,
          ),
          CustomRoute(
            path: 'routing',
            page: RoutingPointsRoute.page,
          ),
          CustomRoute(
            path: 'services',
            page: MapnessServicesRoute.page,
          ),
          AutoRoute(
            path: 'profile',
            page: const EmptyShellRoute('').page,
            children: [
              CustomRoute(
                path: '',
                page: ProfileRoute.page,
                transitionsBuilder: TransitionsBuilders.noTransition,
              ),
              // CustomRoute(
              //   path: 'change_profile_photo_sheet',
              //   page: ChangeProfilePhotoRoute.page,
              //   customRouteBuilder: RouteBuilders.modalSheetBuilder,
              // ),
              CustomRoute(
                path: 'help_center',
                page: HelpCenterRoute.page,
                customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
              ),
            ],
          ),
        ],
      );
}
