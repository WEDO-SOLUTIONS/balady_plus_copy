import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/guards/onboard_route_guard.dart';
import 'package:mapness/app/auto_route/guards/saudi_day_guard.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';
import 'package:mapness/app/auto_route/routes.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

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
            SaudiDaySplashGuard(ref),
          ],
          children: [
            Routes.bottomMenuRoute,
            CustomRoute(
              path: 'kiblah',
              page: KiblahRoute.page,
              fullscreenDialog: true,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'service_available',
              page: ServiceNotAvailableSheetRoute.page,
              opaque: false,
              customRouteBuilder: <T>(context, child, page) =>
                  RouteBuilders.modalSheetBuilder(
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
              path: 'public_routing_details',
              page: RouteDetailsRoute.page,
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
              page: MediaCatalogRoute.page,
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
              path: 'feedback/:objectId',
              page: FeedbackSelectTypeRoute.page,
            ),
            CustomRoute(
              path: ':categoryId',
              page: FeedbackRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'success',
              page: FeedbackSentRoute.page,
            ),
            CustomRoute(
              path: 'favourites',
              page: FavouritesRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
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
              path: 'feedback_v2',
              page: AppFeedbackSheetV2.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              opaque: false,
              fullscreenDialog: true,
              customRouteBuilder: RouteBuilders.customBarrierDismissibleBuilder,
            ),
            CustomRoute(
              path: 'feedback/edit',
              page: AppFeedbackInputSheet.page,
              opaque: false,
              fullscreenDialog: true,
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
            CustomRoute(
              path: 'saudi_pass_offers_screen',
              page: OffersScreenViewRoute.page,
            ),
            AppRoute(
              path: 'saudi_pass_favourite_offers_screen',
              page: FavouriteOffersScreenViewRoute.page,
            ),
            AppRoute(
              path: 'saudi_pass_profile_preferences_screen',
              page: ProfilePreferencesRoute.page,
            ),
            AppRoute(
              path: 'saudi_pass_offers_on_map_screen',
              page: OffersOnMapRoute.page,
            ),
            CustomRoute(
              page: CitySelectionDialogViewRoute.page,
              path: 'saudi_pass_city_selection_dialog',
              opaque: false,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            CustomRoute(
              path: 'saudi_pass_type_selection_dialog',
              page: TypeSelectionDialogViewRoute.page,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'saudi_pass_all_categories_selection_dialog',
              page: AllCategoriesSelectionDialogViewRoute.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            CustomRoute(
              path: 'saudi_pass_sorting_selection_dialog',
              page: SortingSelectionDialogRoute.page,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            AppRoute(
              path: 'saudi_pass_settings_screen',
              page: SettingsScreenViewRoute.page,
            ),
            CustomRoute(
              path: 'saudi_pass_offer_page',
              page: OfferRoute.page,
            ),
            CustomRoute(
              path: 'saudi_pass_offer_feedback',
              page: AppFeedbackSheet.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            CustomRoute(
              path: 'saudi_pass_offer_favorites_removing_sheet',
              page: OfferFavoritesRemovingSheetRoute.page,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'quickFeedback',
              page: QuickFeedbackRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'stories',
              page: StoriesRoute.page,
              opaque: false,
              transitionsBuilder: (_, __, ___, child) => StoriesTransition(
                type: StoryTypes.network,
                child: child,
              ),
            ),
            CustomRoute(
              path: 'settings',
              page: SettingsRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'dark_map',
              page: DarkMapRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'about_balady',
              page: AboutBaladyRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'help_center',
              page: HelpCenterRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'profile_info',
              page: ProfileInfoRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'momra_website',
              page: MomraWebsiteRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'image_editor',
              page: ImageEditorRoute.page,
            ),
            CustomRoute(
              path: 'navigator_settings',
              page: NavigatorSettingsRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'sound_settings',
              page: SoundSettingsRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'voice_settings',
              page: VoiceSettingsRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'photo_viewer',
              page: PhotoViewerRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'language_pick_sheet',
              page: LanguagePickSheetRoute.page,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'flips_continue',
              page: FlipsContinueRoute.page,
            ),
            CustomRoute(
              path: 'contribute',
              page: ContributeRoute.page,
              customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
            ),
            CustomRoute(
              path: 'addPhoto',
              page: AddPhotoRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: RouteBuilders.modalSheetBuilder,
            ),
            CustomRoute(
              path: 'feedback_address_suggester',
              page: FeedbackAddressSuggester.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.slideBottom,
            ),
            AppRoute(
              path: 'profile_preferences',
              page: ProfilePreferencesRoute.page,
            ),
          ],
        ),
        CustomRoute(
          page: OnboardRoute.page,
          opaque: false,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.onboarding,
            child: child,
          ),
        ),
        CustomRoute(
          page: SaudiDaySplashRoute.page,
          opaque: false,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.saudiDay,
            child: child,
          ),
        ),
      ];
}
