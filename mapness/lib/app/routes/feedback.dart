import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/pages/feedback/feedback_page.dart';
import 'package:mapness/pages/feedback/feedback_select_type_page.dart';
import 'package:mapness/pages/feedback/feedback_sent_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'feedback.g.dart';

@TypedGoRoute<FeedbackBaseRoute>(
  path: FeedbackBaseRoute.path,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FeedbackRoute>(
        path: ':categoryId',
        routes: <TypedGoRoute<GoRouteData>>[
          TypedGoRoute<FeedbackSentRoute>(path: 'success'),
        ]),
  ],
)

/// Feedback route. This route is used to report feedback for a specific object.
/// This is the main route that is used to choose the type of feedback.
///
/// We have to provide [objectId] to the route.
class FeedbackBaseRoute extends GoRouteData {
  static const path = '/feedback/:objectId';
  final String objectId;

  const FeedbackBaseRoute({required this.objectId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, String objectId) {
    final route = FeedbackBaseRoute(objectId: objectId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: FeedbackSelectTypePage(objectId: objectId),
      );
}

class FeedbackRoute extends GoRouteData {
  final String categoryId;
  final String objectId;

  const FeedbackRoute({required this.objectId, required this.categoryId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, String objectId, String categoryId) {
    final route = FeedbackRoute(objectId: objectId, categoryId: categoryId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: FeedbackPage(
          poiId: objectId,
          categoryId: categoryId,
        ),
      );
}

class FeedbackSentRoute extends GoRouteData {
  final String objectId;
  final String payloadId;

  const FeedbackSentRoute({required this.payloadId, required this.objectId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, String objectId, String payloadId) {
    final route = FeedbackSentRoute(payloadId: payloadId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: FeedbackSentPage(payloadId: payloadId),
      );
}

final $feedbackRoutes = $appRoutes;
