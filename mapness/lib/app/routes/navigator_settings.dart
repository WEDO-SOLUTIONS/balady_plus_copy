import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/components/language_pick_sheet.dart';
import 'package:mapness/pages/navigator_settings/pages/navigator_settings_page.dart';
import 'package:mapness/pages/navigator_settings/pages/sound_settings_page.dart';
import 'package:mapness/pages/navigator_settings/pages/voice_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'navigator_settings.g.dart';

@TypedGoRoute<NavigatorSettingsRoute>(
  path: NavigatorSettingsRoute.path,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SoundSettingsRoute>(
      path: SoundSettingsRoute.path,
    ),
    TypedGoRoute<VoiceSettingsRoute>(path: VoiceSettingsRoute.path, routes: [
      TypedGoRoute<LanguagePickSheetRoute>(
        path: LanguagePickSheetRoute.path,
      ),
    ]),
  ],
)
class NavigatorSettingsRoute extends GoRouteData {
  static const path = '/navigator_settings';

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
  static const path = 'sound_settings';

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
  static const path = 'voice_settings';

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
  static const path = 'language_pick_sheet';

  const LanguagePickSheetRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context) {
    const route = LanguagePickSheetRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        barrierColor: context.color.surfaceOverlayModal,
        barrierDismissible: true,
        transitionsBuilder: (_, animation, ___, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
        child: const LanguagePickSheet(),
      );
}

final $navigatorSettingsRoutes = $appRoutes;
