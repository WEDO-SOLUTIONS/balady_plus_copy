import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/pages/voice_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'voice_settings.g.dart';

@TypedGoRoute<VoiceSettingsRoute>(
  path: VoiceSettingsRoute.path,
)
class VoiceSettingsRoute extends GoRouteData {
  static const path = '/voice_settings';

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

final $voiceSettingsRoutes = $appRoutes;
