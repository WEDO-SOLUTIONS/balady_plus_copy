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
        ),
        CustomRoute(
          path: '/dark_map',
          page: DarkMapRoute.page,
        ),
        CustomRoute(
          path: '/about_balady',
          page: AboutBaladyRoute.page,
        ),
        CustomRoute(
          path: '/help_center',
          page: HelpCenterRoute.page,
        ),
        CustomRoute(
          path: '/profile_info',
          page: ProfileInfoRoute.page,
        ),
        CustomRoute(
          path: '/momra_website',
          page: MomraWebsiteRoute.page,
        ),
        CustomRoute(
          path: '/image_editor',
          page: ImageEditorRoute.page,
        ),
        CustomRoute(
          path: '/navigator_settings',
          page: NavigatorSettingsRoute.page,
        ),
        CustomRoute(
          path: '/sound_settings',
          page: SoundSettingsRoute.page,
        ),
        CustomRoute(
          path: '/voice_settings',
          page: VoiceSettingsRoute.page,
        ),
        CustomRoute(
          path: '/photo_viewer',
          page: PhotoViewerRoute.page,
        ),
        CustomRoute(
          path: '/profile_preferences',
          page: ProfilePreferencesRoute.page,
        ),
        CustomRoute(
          page: CitySelectionDialogViewRoute.page,
          path: '/saudi_pass_city_selection_dialog',
          opaque: false,
        ),
        CustomRoute(
          path: '/language_pick_sheet',
          page: LanguagePickSheetRoute.page,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: '/flips_continue',
          page: FlipsContinueRoute.page,
        ),
        CustomRoute(
          path: '/addPhoto',
          page: AddPhotoRoute.page,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          customRouteBuilder: RouteBuilders.modalSheetBuilder,
        ),
        CustomRoute(
          path: '/feedback_address_suggester',
          page: FeedbackAddressSuggester.page,
          opaque: false,
          transitionsBuilder: TransitionsBuilders.slideBottom,
        ),
        CustomRoute(
          path: '/feedback/edit',
          page: AppFeedbackInputSheet.page,
          opaque: false,
          transitionsBuilder: TransitionsBuilders.slideBottom,
        ),
      ];

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
              CustomRoute(
                path: 'change_profile_photo_sheet',
                page: ChangeProfilePhotoRoute.page,
                customRouteBuilder: RouteBuilders.modalSheetBuilder,
              ),
            ],
          ),
        ],
      );
}
