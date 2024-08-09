import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/feedback/feedback_company_name_page.dart';
import 'package:mapness/pages/feedback/feedback_types_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'feedback.g.dart';

@TypedGoRoute<FeedbackRoute>(
  path: FeedbackRoute.path,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FeedbackCompanyNameRoute>(path: 'company_name'),
  ],
)
class FeedbackRoute extends GoRouteData {
  static const path = '/feedback';
  final String? title;
  final String? subtitle;

  const FeedbackRoute({
    this.subtitle,
    this.title,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, String title, String subtitle) {
    final route = FeedbackRoute(title: title, subtitle: subtitle);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: FeedbackTypesPage(
          poiTitle: title ?? '',
          address: subtitle ?? '',
        ),
      );
}

/// Company name feedback page. If the user decides to report an error in the company name.
/// We have to provide [initialCompanyName] to the page.
class FeedbackCompanyNameRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  final String initialCompanyName;
  const FeedbackCompanyNameRoute(this.initialCompanyName);

  static void open(GoRouter router, String initialCompanyName) {
    final route = FeedbackCompanyNameRoute(initialCompanyName);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: FeedbackCompanyNamePage(
          initialCompanyName: initialCompanyName,
        ),
      );
}

final $feedbackRoutes = $appRoutes;
