import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/guards/navigation_guard.dart';
import 'package:mapness/app/auto_route/guards/onboard_route_guard.dart';
import 'package:mapness/app/auto_route/guards/theme_splash_guard.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';
import 'package:mapness/app/auto_route/routes.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

import 'app_routes.gr.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref, rootNavigatorKey));
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref, GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey: navigatorKey);

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
      // Note: ThemeSplashGuard uses MaterialPageRoute directly because auto_route
      // can't generate code for routes with enum parameters (SpecialThemeMode).
      // The guard dynamically shows splash screens based on the current theme.
      guards: [OnboardRouteGuard(ref), ThemeSplashGuard(ref)],
      children: [
        Routes.bottomMenuRoute,
        CustomRoute(
          path: 'kiblah',
          page: KiblahRoute.page,
          fullscreenDialog: true,
          customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
        ),
        CustomRoute(
          path: 'nearby',
          page: NearbyRoute.page,
          fullscreenDialog: true,
          customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
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
        CustomRoute(
          path: 'exit_navigation',
          page: ExitNavigationRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        // BE-153: fade so the search sheet appears in-place (matches Google Maps),
        // instead of the default cupertino slide. Short duration keeps the tap → keyboard
        // path snappy and avoids competing with the keyboard animation.
        AppRoute(
          path: 'search',
          page: SearchRoute.page,
          durationInMilliseconds: 150,
          reverseDurationInMilliseconds: 150,
          transitionsBuilder: TransitionsBuilders.fadeIn,
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
        AppRoute(path: 'poi-makkah', page: PoiMakkahWidgetRoute.page),
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
        CustomRoute(
          path: 'share_route',
          page: ShareRouteRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
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
        AppRoute(
          path: 'favourites_search',
          page: FavouritesSearchRoute.page,
          durationInMilliseconds: 150,
          reverseDurationInMilliseconds: 150,
          transitionsBuilder: TransitionsBuilders.fadeIn,
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
          path: 'favorite_lists',
          page: FavoriteListsRoute.page,
          fullscreenDialog: true,
          customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
        ),
        CustomRoute(
          path: 'edit_my_addresses',
          page: EditMyAddressesRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'create_or_update_favorite_list',
          page: CreateOrUpdateFavoriteListRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'favorite_item_menu',
          page: FavoriteItemMenuRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'confirmation_sheet',
          page: ConfirmationSheetRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'edit_favorite_list_item_name',
          page: EditFavoriteListItemNameRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'pick_favorite_list',
          page: PickFavoriteListRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'marker_color_picker',
          page: MarkerColorPickerRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'favorite_list_details',
          page: FavoriteListDetailsRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: 'favorite_list_menu',
          page: FavoriteListMenuRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
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
          path: 'remove_history_confirmation',
          page: RemoveHistoryConfirmationRoute.page,
          opaque: false,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
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
          path: 'privacy_and_terms_of_use',
          page: PrivacyAndTermsOfUseRoute.page,
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
          path: 'profile_logout_sheet',
          page: ProfileLogoutSheetRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
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
          path: 'gaussian_splatting',
          page: GaussianSplattingRoute.page,
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
    // NOTE: SaudiDaySplashRoute deprecated - replaced by ThemeSplashPage
    // The guard now uses MaterialPageRoute directly instead of auto_route
    // CustomRoute(
    //   page: SaudiDaySplashRoute.page,
    //   opaque: false,
    //   transitionsBuilder:
    //       (_, __, ___, child) =>
    //           StoriesTransition(type: StoryTypes.saudiDay, child: child),
    // ),
    // NOTE: ThemeSplashRoute is used programmatically only (not in routes list)
    // Auto_route has issues generating code when routes have enum parameters.
    // Use context.router.push(MaterialPageRoute(...)) instead in guards/debug panel.
    // CustomRoute(
    //   page: ThemeSplashRoute.page,
    //   opaque: false,
    //   transitionsBuilder: TransitionsBuilders.fadeIn,
    // ),
  ];

  @override
  List<AutoRouteGuard> get guards => [NavigationGuard(ref)];
}
