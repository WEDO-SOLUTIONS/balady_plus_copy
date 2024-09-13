import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/pages/sound_settings_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'sound_settings.g.dart';

@TypedGoRoute<SoundSettingsRoute>(
  path: SoundSettingsRoute.path,
)
class SoundSettingsRoute extends GoRouteData {
  static const path = '/sound_settings';

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

final $soundSettingsRoutes = $appRoutes;
