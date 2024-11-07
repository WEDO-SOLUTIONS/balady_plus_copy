import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/app_feedback/app_feedback_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'app_feedback.g.dart';

@TypedGoRoute<AppFeedbackRoute>(
  path: AppFeedbackRoute.path,
)
class AppFeedbackRoute extends GoRouteData {
  static const path = '/app_feedback';

  const AppFeedbackRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
        child: AppFeedbackPage(),
      );
}

final $appFeedbackRoutes = $appRoutes;
