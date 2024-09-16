import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/free_roam/ui/road_panel_sheet.dart';

part 'road_panel.g.dart';

@TypedGoRoute<RoadPanelRoute>(
  path: RoadPanelRoute.path,
)
class RoadPanelRoute extends GoRouteData {
  const RoadPanelRoute();

  static const path = '/road_panel';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context) {
    const route = RoadPanelRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        transitionsBuilder: (_, __, ___, child) => child,
        barrierColor: context.staticColor.surfaceOverlayModal,
        barrierDismissible: true,
        child: const RoadPanelSheet(key: Key('ROAD PANEL WIDGET')),
      );
}

final $roadPanelRoutes = $appRoutes;
