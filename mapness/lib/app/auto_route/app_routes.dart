import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';
import 'package:mapness/app/auto_route/routes.dart';

import 'app_routes.gr.dart';
import 'others/onboard_route_guard.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref));
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

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
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'service_available',
              page: ServiceNotAvailableSheetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
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
            CustomRoute(
              path: 'path_nav',
              page: PathNavRoute.page,
              fullscreenDialog: true,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            CustomRoute(
              path: 'routing_map',
              page: RoutingMapSelectRoute.page,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'poi_card',
              page: PoiCardWidgetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'deeplink',
              page: DeeplinkRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'routing_routes',
              page: RoutingRoutesRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'eta_roue',
              page: EtaRouteRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'weather_router',
              page: WeatherRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              page: RoutingSearchSheetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'road_panel_sheet',
              page: RoadPanelSheetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'free_roam',
              page: FreeRoamRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'road_closure',
              page: RoadClosureRoute.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'auto_start_settings',
              page: AutostartSettingsSheetRoute.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'layers_details',
              page: LayersDetailsWidgetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'shared_my_location',
              barrierDismissible: false,
              page: ShareMyLocationRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/card',
              barrierDismissible: false,
              page: IwishPlaceCardRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/feedback',
              barrierDismissible: false,
              page: IwishFeedbackContainerRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/comment',
              barrierDismissible: false,
              page: IwishFeedbackCommentRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: RouteBuilders.customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'layers_sheet',
              transitionsBuilder: TransitionsBuilders.fadeIn,
              fullscreenDialog: true,
              allowSnapshotting: false,
              barrierDismissible: false,
              page: LayersSheetRoute.page,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'feedback/:objectId',
              transitionsBuilder: TransitionsBuilders.fadeIn,
              page: FeedbackSelectTypeRoute.page,
            ),
            CustomRoute(
              path: ':categoryId',
              page: FeedbackRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'success',
              page: FeedbackSentRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'favourites',
              page: FavouritesRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'search',
              page: FavouritesSearchRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              page: DeleteAllContentRoute.page,
              path: 'delete_all',
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              page: FavouritesPickerRoute.page,
              path: 'picker',
              transitionsBuilder: TransitionsBuilders.fadeIn,
            )
          ],
        ),
        ...Routes.upperRoutesMap,
      ];
}
