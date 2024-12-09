import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/guards/onboard_route_guard.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';
import 'package:mapness/app/auto_route/routes.dart';

import 'app_routes.gr.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref, rootNavigatorKey));
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(
    this.ref,
    GlobalKey<NavigatorState> navigatorKey,
  ) : super(navigatorKey: navigatorKey);

  final Ref ref;

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MapRoute.page,
          path: '/',
          initial: true,
          guards: [
            OnboardRouteGuard(ref),
          ],
          children: [
            Routes.bottomMenuRoute,
            CustomRoute(
              path: 'kiblah',
              page: KiblahRoute.page,
              fullscreenDialog: true,
            ),
            CustomRoute(
              path: 'service_available',
              page: ServiceNotAvailableSheetRoute.page,
              opaque: false,
              customRouteBuilder: <T>(context, child, page) => RouteBuilders.modalSheetBuilder(
                context,
                child,
                page,
                isTransparent: true,
              ),
            ),
            CustomRoute(
              path: 'request_location',
              page: LocationErrorSheetRoute.page,
            ),
            AppRoute(
              path: 'path_nav',
              page: PathNavRoute.page,
              fullscreenDialog: true,
            ),
            AppRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            AppRoute(
              path: 'routing_map',
              page: RoutingMapSelectRoute.page,
            ),
            AppRoute(
              path: 'poi_card',
              page: PoiCardWidgetRoute.page,
            ),
            CustomRoute(
              path: 'deeplink',
              page: DeeplinkRoute.page,
            ),
            AppRoute(
              path: 'routing_routes',
              page: RoutingRoutesRoute.page,
            ),
            AppRoute(
              path: 'eta_route/:lat/:lon',
              page: EtaRouteRoute.page,
            ),
            AppRoute(
              path: 'weather_router',
              page: WeatherRoute.page,
            ),
            AppRoute(
              page: RoutingSearchSheetRoute.page,
            ),
            CustomRoute(
              path: 'road_panel_sheet',
              page: RoadPanelSheetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            AppRoute(
              path: 'free_roam',
              page: FreeRoamRoute.page,
              fullscreenDialog: true,
            ),
            AppRoute(
              path: 'road_closure',
              page: RoadClosureRoute.page,
            ),
            AppRoute(
              path: 'auto_start_settings',
              page: AutostartSettingsSheetRoute.page,
            ),
            CustomRoute(
              path: 'layers_details',
              page: LayersDetailsWidgetRoute.page,
              fullscreenDialog: true,
              opaque: false,
            ),
            AppRoute(
              path: 'shared_my_location',
              barrierDismissible: false,
              page: ShareMyLocationRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            AppRoute(
              path: 'iwish/:iwishId/card',
              barrierDismissible: false,
              page: IwishPlaceCardRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            AppRoute(
              path: 'iwish/:iwishId/feedback',
              barrierDismissible: false,
              page: IwishFeedbackContainerRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            AppRoute(
              path: 'iwish/:iwishId/comment',
              barrierDismissible: false,
              page: IwishFeedbackCommentRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            CustomRoute(
              path: 'layers_sheet',
              page: LayersSheetRoute.page,
            ),
            CustomRoute(
              path: 'feedback/:objectId',
              page: FeedbackSelectTypeRoute.page,
            ),
            CustomRoute(
              path: ':categoryId',
              page: FeedbackRoute.page,
            ),
            CustomRoute(
              path: 'success',
              page: FeedbackSentRoute.page,
            ),
            CustomRoute(
              path: 'favourites',
              page: FavouritesRoute.page,
            ),
            CustomRoute(
              path: 'search',
              page: FavouritesSearchRoute.page,
            ),
            CustomRoute(
              page: DeleteAllContentRoute.page,
              path: 'delete_all',
            ),
            CustomRoute(
              page: FavouritesPickerRoute.page,
              path: 'picker',
            ),
            CustomRoute(
              path: 'feedback',
              page: AppFeedbackSheet.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            CustomRoute(
              path: 'feedback/edit',
              page: AppFeedbackInputSheet.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
          ],
        ),
        ...Routes.upperRoutesMap,
      ];
}
