import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/entities/mini_apps/presentation_mode.dart';
import 'package:mapness/pages/mini_apps/bottom_sheet.dart';
import 'package:mapness/pages/mini_apps/full_screen.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'mini_apps.g.dart';

@TypedGoRoute<MiniAppRoute>(
  path: '/mini-app',
)
class MiniAppRoute extends GoRouteData {
  const MiniAppRoute(this.mode, this.title);

  final MiniAppPresentation mode;
  final String title;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: switch (mode) {
          MiniAppPresentation.bottomSheet => MiniAppBottomSheet(
              title: title,
            ),
          MiniAppPresentation.fullScreen => MiniAppFullScreen(
              title: title,
            ),
        },
      );
}

final $miniAppsRoutes = $appRoutes;
