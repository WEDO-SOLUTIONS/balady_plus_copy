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
        AppRoute(
          page: MapRoute.page,
          path: '/',
          initial: true,
          transitionsBuilder: TransitionsBuilders.zoomIn,
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
                background: RouteBarrierColor.transparent,
              ),
            ),
            CustomRoute(
              path: 'request_location',
              page: LocationErrorSheetRoute.page,
            ),
            AppRoute(
              path: 'pathNav',
              page: PathNavRoute.page,
              fullscreenDialog: true,
            ),
            AppRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            AppRoute(
              path: 'navi_search',
              page: NaviSearchRoute.page,
            ),
            AppRoute(
              path: 'routingMap',
              page: RoutingMapSelectRoute.page,
            ),
            CustomRoute(
              path: 'parking_add',
              page: ParkingSpotRoute.page,
            ),
            AppRoute(
              path: 'poi-map',
              page: PoiCardWidgetRoute.page,
            ),
            AppRoute(
              path: 'hajj-poi-card',
              page: HajjPoiCardRoute.page,
            ),
            CustomRoute(
              path: 'deeplink',
              page: DeeplinkRoute.page,
            ),
            AppRoute(
              path: 'routingRoutes',
              page: RoutingRoutesRoute.page,
            ),
            AppRoute(
              transitionsBuilder: TransitionsBuilders.slideBottom,
              durationInMilliseconds: 250,
              path: 'routingSearch',
              page: RoutingSearchSheetRoute.page,
            ),
            AppRoute(
              path: 'eta_route/:lat/:lon',
              page: EtaRouteRoute.page,
            ),
            AppRoute(
              path: 'weather_router',
              page: WeatherRoute.page,
            ),
            CustomRoute(
              path: 'media_catalog',
              page: MediaCatalogScreen.page,
            ),
            CustomRoute(
              path: 'road_panel_sheet',
              page: RoadPanelSheetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            AppRoute(
              path: 'freeRoam',
              page: FreeRoamRoute.page,
              fullscreenDialog: true,
            ),
            AppRoute(
              path: 'road_closed',
              page: RoadClosedRoute.page,
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
              path: 'add_phtoto_feedback',
              page: QuickFeedbackPhotoRoute.page,
            ),
            CustomRoute(
              path: 'quickFeedback',
              page: QuickFeedbackRoute.page,
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
              path: 'navi_search_favorites',
              page: NaviFavoritesRoute.page,
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
            CustomRoute(
              path: 'poi_favorite_dialog',
              page: PoiFavoriteDialogRoute.page,
            ),
            CustomRoute(
              path: 'error_sheet_dialog',
              page: ErrorSheetDialogRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'delete_parking',
              page: ParkingDialogRoute.page,
              opaque: false,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
          ],
        ),
        ...Routes.upperRoutesMap,
      ];
}
