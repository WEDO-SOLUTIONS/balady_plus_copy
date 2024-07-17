import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_screen.dart';
import 'package:mapness/shared/extensions/router_extension.dart';

part 'stories.g.dart';

@TypedGoRoute<StoriesRoute>(
  path: '/stories',
)
class StoriesRoute extends GoRouteData {
  final StoryTypes type;
  const StoriesRoute({
    required this.type,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void openRoute(BuildContext context) {
    _open(context, StoryTypes.route);
  }

  static void openOnboarding(BuildContext context) {
    _open(context, StoryTypes.onboarding);
  }

  static void _open(BuildContext context, StoryTypes type) {
    final storiesRoute = StoriesRoute(
      type: type,
    );
    final router = GoRouter.of(context);
    if (router.isCurrentRoute(storiesRoute.location)) {
      router.pushReplacement(storiesRoute.location);
      return;
    }
    router.push(storiesRoute.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => CustomTransitionPage(
        child: StoriesScreen(
          type: type,
        ),
        fullscreenDialog: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child),
      );
}

final $storiesRoutes = $appRoutes;
