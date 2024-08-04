import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/profile/pages/about_balady_page.dart';
import 'package:mapness/_features/profile/pages/help_center_page.dart';
import 'package:mapness/_features/profile/pages/image_editor_page.dart';
import 'package:mapness/_features/profile/pages/momra_website_page.dart';
import 'package:mapness/_features/profile/pages/profile_info_page.dart';
import 'package:mapness/_features/profile/pages/profile_page.dart';
import 'package:mapness/_features/profile/pages/settings_page.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'profile.g.dart';

@TypedGoRoute<ProfileRoute>(
  path: '/profile',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
    ),
    TypedGoRoute<HelpCenterRoute>(
      path: 'help_center',
    ),
    TypedGoRoute<AboutBaladyRoute>(
      path: 'about_balady',
    ),
    TypedGoRoute<MomraWebsitePageRoute>(
      path: 'momra_website',
    ),
    TypedGoRoute<ProfileInfoPageRoute>(
      path: 'info',
    ),
    TypedGoRoute<ImageEditorRoute>(
      path: 'image_editor',
    ),
  ],
)
class ProfileRoute extends GoRouteData {
  const ProfileRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: ProfilePage(),
      );
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: SettingsPage(),
      );
}

class ImageEditorRoute extends GoRouteData {
  const ImageEditorRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final extra = state.extra! as Uint8List;

    return TransculentPage(
      child: ImageEditorPage(extra),
    );
  }
}

class HelpCenterRoute extends GoRouteData {
  const HelpCenterRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: HelpCenterPage(),
      );
}

class AboutBaladyRoute extends GoRouteData {
  const AboutBaladyRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: AboutBaladyPage(),
      );
}

class MomraWebsitePageRoute extends GoRouteData {
  const MomraWebsitePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: MomraWebsitePage(),
      );
}

class ProfileInfoPageRoute extends GoRouteData {
  const ProfileInfoPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: ProfileInfoPage(),
      );
}

final $profileRoutes = $appRoutes;
