import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/others/transparent_barrier.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

import 'app_routes.gr.dart';
import 'others/onboard_route_guard.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref));
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

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
          opaque: false,
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
        CustomRoute(
          path: '/settings',
          page: SettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/dark_map',
          page: DarkMapRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/about_balady',
          page: AboutBaladyRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/help_center',
          page: HelpCenterRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/profile_info',
          page: ProfileInfoRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/momra_website',
          page: MomraWebsiteRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/image_editor',
          page: ImageEditorRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/signin',
          page: SigninRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/navigator_settings',
          page: NavigatorSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/sound_settings',
          page: SoundSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/voice_settings',
          page: VoiceSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/language_pick_sheet',
          page: LanguagePickSheetRoute.page,
          fullscreenDialog: true,
          opaque: false,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          page: MapRoute.page,
          path: '/',
          initial: true,
          guards: [
            OnboardRouteGuard(ref),
          ],
          children: [
            CustomRoute(
              path: 'bottom_menu',
              page: BottomMenuRoute.page,
              initial: true,
              barrierDismissible: false,
              customRouteBuilder: customModalSheetBuilder,
              children: [
                CustomRoute(
                  path: 'explore',
                  initial: true,
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
            CustomRoute(
              path: 'kiblah',
              page: KiblahRoute.page,
              fullscreenDialog: true,
              transitionsBuilder: TransitionsBuilders.fadeIn,
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
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            CustomRoute(
              path: 'routing_map',
              page: RoutingMapSelectRoute.page,
            ),
            CustomRoute(
              path: 'poi_card',
              page: PoiCardWidgetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
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
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'eta_roue',
              page: EtaRouteRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'weather_router',
              page: WeatherRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              page: RoutingSearchSheetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'road_panel_sheet',
              page: RoadPanelSheetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: modalSheetBuilder,
            ),
            CustomRoute(
              path: 'free_roam',
              page: FreeRoamRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'road_closure',
              page: RoadClosureRoute.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'auto_start_settings',
              page: AutostartSettingsSheetRoute.page,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'layers_details',
              page: LayersDetailsWidgetRoute.page,
              fullscreenDialog: true,
              opaque: false,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'shared_my_location',
              barrierDismissible: false,
              page: ShareMyLocationRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/card',
              barrierDismissible: false,
              page: IwishPlaceCardRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/feedback',
              barrierDismissible: false,
              page: IwishFeedbackContainerRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'iwish/:iwishId/comment',
              barrierDismissible: false,
              page: IwishFeedbackCommentRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'layers_sheet',
              transitionsBuilder: TransitionsBuilders.fadeIn,
              fullscreenDialog: true,
              allowSnapshotting: false,
              barrierDismissible: false,
              page: LayersSheetRoute.page,
              customRouteBuilder: modalSheetBuilder,
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
      ];

  /// Creates a modal bottom sheet route (ModalBottomSheetRoute),
  /// using colors from the UI kit for the modal surface.
  ///
  /// - [context] provides information about the current widget state.
  /// - [child] is the widget that will be displayed in the modal sheet.
  /// - [page] represents the route page, passed as an AutoRoutePage.
  ///
  /// This method sets up the following parameters:
  /// - [isScrollControlled] enables scroll control in the modal.
  /// - [modalBarrierColor] uses a color from the UI kit for the modal barrier
  ///   that blocks interaction with the rest of the UI while the modal is open.
  /// - [backgroundColor] is set to `Colors.transparent` to avoid a background overlay.
  ///
  ///  Using in [CustomRoute] call [customRouteBuilder]
  Route<T> modalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) =>
      ModalBottomSheetRoute(
        settings: page,
        builder: (context) => child,
        isScrollControlled: true,
        modalBarrierColor: context.staticColor.surfaceOverlayModal,
        backgroundColor: Colors.transparent,
      );

  /// Creates a custom modal route (CustomModalRoute) that removes the navigation barrier,
  /// allowing access to routes behind the modal window.
  ///
  /// - [context] provides information about the current widget state.
  /// - [child] is the widget that will be displayed in the modal window.
  /// - [page] represents the route page, passed as an AutoRoutePage.
  ///
  /// This method sets up a route without a barrier, allowing the user
  /// to interact with navigation elements or other routes behind the modal window.
  Route<T> customModalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) =>
      CustomModalRoute(page: page);
}
