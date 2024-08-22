import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings_pages/navigator_settings_page.dart';
import 'package:mapness/pages/navigator_settings_pages/sound_settings_page.dart';
import 'package:mapness/pages/navigator_settings_pages/voice_page/voice_page.dart';
import 'package:mapness/pages/navigator_settings_pages/voice_page/widgets/language_pick_sheet.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'navigator_settings.g.dart';

@TypedGoRoute<NavigatorSettingsRoute>(
  path: '/navigator_settings',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SoundSettingsRoute>(
      path: 'sound_settings',
    ),
    TypedGoRoute<VoiceSettingsRoute>(
      path: 'voice_settings',
    ),
    TypedGoRoute<LanguagePickSheetRoute>(
      path: 'language_pick_sheet',
    ),
  ],
)
class NavigatorSettingsRoute extends GoRouteData {
  const NavigatorSettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TransculentPage(
        child: NavigatorSettingsPage(),
      );
}

class SoundSettingsRoute extends GoRouteData {
  const SoundSettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TransculentPage(
        child: SoundSettingsPage(),
      );
}

class VoiceSettingsRoute extends GoRouteData {
  const VoiceSettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TransculentPage(
        child: VoiceSettingsPage(),
      );
}

class LanguagePickSheetRoute extends GoRouteData {
  const LanguagePickSheetRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TransculentPage(
        child: LanguagePickSheet(),
      );
}

final $navigatorSettingsRoutes = $appRoutes;
