import 'package:auto_route/auto_route.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/others/route_builder.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

class Routes {
  static List<AutoRoute> get upperRoutesMap => [
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
          path: '/photo_viewer',
          page: PhotoViewerRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          path: '/language_pick_sheet',
          page: LanguagePickSheetRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
      ];

  static AutoRoute get bottomMenuRoute => CustomRoute(
        path: 'bottom_menu',
        page: BottomMenuRoute.page,
        initial: true,
        barrierDismissible: false,
        customRouteBuilder: RouteBuilders.customModalSheetBuilder,
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
      );
}
