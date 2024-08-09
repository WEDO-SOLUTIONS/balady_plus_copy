import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/feedback/feedback_pages/feedback_area_of_activity_page.dart';
import 'package:mapness/pages/feedback/feedback_pages/feedback_company_name_page.dart';
import 'package:mapness/pages/feedback/feedback_types_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'feedback.g.dart';

@TypedGoRoute<FeedbackRoute>(
  path: FeedbackRoute.path,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FeedbackCompanyNameRoute>(path: 'company_name'),
    TypedGoRoute<FeedbackAreaOfActivityRoute>(path: 'area_of_activity'),
  ],
)

/// Feedback route. This route is used to report feedback for a specific object.
/// This is the main route that is used to choose the type of feedback.
///
/// We have to provide [objectId] to the route.
class FeedbackRoute extends GoRouteData {
  static const path = '/feedback/:objectId';
  final String objectId;

  const FeedbackRoute({required this.objectId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, String objectId) {
    final route = FeedbackRoute(objectId: objectId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: FeedbackTypesPage(objectId: objectId),
      );
}

/// Company name feedback page. If the user decides to report an error in the company name.
///
/// We have to provide [initialCompanyName] and [objectId] to the page.
class FeedbackCompanyNameRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  /// Initial company name to show in the text field.
  final String initialCompanyName;

  /// Object id to report feedback for.
  final String objectId;

  const FeedbackCompanyNameRoute(this.initialCompanyName, this.objectId);

  /// Static method to open the route with the given [initialCompanyName] and [objectId].
  static void open(GoRouter router, String initialCompanyName, String objectId) {
    final route = FeedbackCompanyNameRoute(initialCompanyName, objectId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: FeedbackCompanyNamePage(
          initialCompanyName: initialCompanyName,
        ),
      );
}

/// Area of activity feedback page. If the user decides to report an error of the activity of
/// the object (e.g. a restaurant is marked as a shop).
///
/// We have to provide [initialAreaOfActivity] and [objectId] to the page.
class FeedbackAreaOfActivityRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  /// Initial area of activity to show in the text field.
  final String initialAreaOfActivity;

  /// Object id to report feedback for.
  final String objectId;

  const FeedbackAreaOfActivityRoute(this.initialAreaOfActivity, this.objectId);

  /// Static method to open the route with the given [initialAreaOfActivity] and [objectId].
  static void open(GoRouter router, String initialAreaOfActivity, String objectId) {
    final route = FeedbackCompanyNameRoute(initialAreaOfActivity, objectId);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: FeedbackAreaOfActivityPage(
          initialAreaOfActivity: initialAreaOfActivity,
        ),
      );
}

final $feedbackRoutes = $appRoutes;
