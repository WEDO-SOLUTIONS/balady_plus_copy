import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/pages/navigator_settings_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'navigator_settings.g.dart';

@TypedGoRoute<NavigatorSettingsRoute>(
  path: NavigatorSettingsRoute.path,
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

final $navigatorSettingsRoutes = $appRoutes;
