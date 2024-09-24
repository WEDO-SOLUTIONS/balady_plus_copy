import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/free_roam/ui/autostart_settings_sheet.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'free_roam_autostart_settings.g.dart';

@TypedGoRoute<FreeRoamAutostartSettingsRoute>(
  path: FreeRoamAutostartSettingsRoute.path,
)
class FreeRoamAutostartSettingsRoute extends GoRouteData {
  const FreeRoamAutostartSettingsRoute();

  static const path = '/free_roam_autostart_settings';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context) {
    const route = FreeRoamAutostartSettingsRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: AutostartSettingsSheet(key: Key('FREE ROAM AUTO START SETTINGS WIDGET')),
      );
}

final $freeRoamAutostartSettingsRoutes = $appRoutes;
