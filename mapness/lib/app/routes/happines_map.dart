import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/happiness_map/presentation/happines_feedback_comment.dart';
import 'package:mapness/_features/happiness_map/presentation/happines_overlay_content.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'happines_map.g.dart';

@TypedGoRoute<HappinessMapRoute>(
    path: '/happines_map',
    routes: <TypedGoRoute<GoRouteData>>[
      TypedGoRoute<HappinessMapCommentRoute>(path: 'comment'),
    ],)
class HappinessMapRoute extends GoRouteData {

  const HappinessMapRoute({this.bottomSheetOpened});
  final bool? bottomSheetOpened;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: HappinesOverlayContent(
          isBottomSheetOpened: bottomSheetOpened ??
              state.uri.queryParameters.containsKey('bottom-sheet-opened'),
        ),
      ),
    );
}

class HappinessMapCommentRoute extends GoRouteData {
  const HappinessMapCommentRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _happinesTransition(
        context: context,
        child: HappinesFeedbackComment(),
      );
}

TransculentPage<void> _happinesTransition({
  required BuildContext context,
  required Widget child,
}) => TransculentPage(
    child: Directionality(
      textDirection: Directionality.of(context),
      child: Align(alignment: Alignment.bottomCenter, child: child),
    ),
  );

final $happinesMapRoutes = $appRoutes;
