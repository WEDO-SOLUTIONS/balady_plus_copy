import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/iwish/ui/iwish_carousel.dart';
import 'package:mapness/pages/iwish/ui/iwish_feedback.dart';
import 'package:mapness/pages/iwish/ui/iwish_feedback_comment.dart';
import 'package:mapness/pages/iwish/ui/iwish_place_card.dart';

part 'iwish.g.dart';

@TypedGoRoute<IwishRoute>(
  path: '/iwish',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<IwishCardRoute>(path: 'card/:iwishId'),
    TypedGoRoute<IwishFeedbackRoute>(path: 'feedback/:iwishId'),
    TypedGoRoute<IwishFeedbackCommentRoute>(path: 'comment/:iwishId')
  ],
)
class IwishRoute extends GoRouteData {
  const IwishRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _iwishTransition(context: context, child: const IwishCarousel());
  }
}

@immutable
class IwishCardRoute extends GoRouteData {
  final String iwishId;

  const IwishCardRoute({required this.iwishId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _iwishTransition(
      context: context,
      child: IwishPlaceCard(iwishId: iwishId),
    );
  }
}

@immutable
class IwishFeedbackRoute extends GoRouteData {
  final String iwishId;

  const IwishFeedbackRoute({required this.iwishId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _iwishTransition(
      context: context,
      child: IwishFeedback(iwishId: iwishId),
    );
  }
}

@immutable
class IwishFeedbackCommentRoute extends GoRouteData {
  final String iwishId;

  const IwishFeedbackCommentRoute({required this.iwishId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _iwishTransition(
      context: context,
      child: IwishFeedbackComment(iwishId: iwishId),
    );
  }
}

CustomTransitionPage<void> _iwishTransition({
  required BuildContext context,
  required Widget child,
}) =>
    CustomTransitionPage(
      fullscreenDialog: true,
      opaque: false,
      transitionsBuilder: (_, __, ___, child) => child,
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Align(alignment: Alignment.bottomCenter, child: child),
          ),
        ),
      ),
    );

final $iwishRoutes = $appRoutes;
