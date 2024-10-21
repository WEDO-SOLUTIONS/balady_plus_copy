import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/pages/iwish/iwish_feedback_comment.dart';
import 'package:mapness/pages/iwish/iwish_feedback_container.dart';
import 'package:mapness/pages/iwish/iwish_place_card.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'iwish.g.dart';

@TypedGoRoute<IwishCardRoute>(path: '/iwish/:iwishId/card')
@immutable
class IwishCardRoute extends GoRouteData {
  const IwishCardRoute({required this.iwishId});
  static const path = '/iwish';
  final String iwishId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, IwishMarker marker) {
    final route = IwishCardRoute(iwishId: marker.id);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation.contains(path) ||
        matches.last.matchedLocation == (PoiCardWidgetRoute.name)) {
      router.pushReplacement(route.location);
    } else {
      router.push(route.location);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _iwishTransition(
        context: context,
        child: IwishPlaceCard(iwishId: iwishId),
      );
}

@TypedGoRoute<IwishFeedbackRoute>(path: '/iwish/:iwishId/feedback')
@immutable
class IwishFeedbackRoute extends GoRouteData {
  const IwishFeedbackRoute({required this.iwishId});
  final String iwishId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _iwishTransition(
        context: context,
        child: IwishFeedbackContainer(iwishId: iwishId),
      );
}

@TypedGoRoute<IwishFeedbackCommentRoute>(path: '/iwish/:iwishId/comment')
@immutable
class IwishFeedbackCommentRoute extends GoRouteData {
  const IwishFeedbackCommentRoute({required this.iwishId});
  final String iwishId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _iwishTransition(
        context: context,
        child: Material(child: IwishFeedbackComment(iwishId: iwishId)),
      );
}

TransculentPage<void> _iwishTransition({
  required BuildContext context,
  required Widget child,
}) =>
    TransculentPage(
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: Directionality(
            textDirection: Directionality.of(context),
            child: Align(alignment: Alignment.bottomCenter, child: child),
          ),
        ),
      ),
    );

final $iwishRoutes = $appRoutes;
