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
  const StoriesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void openRoute(
    BuildContext context, {
    VoidCallback? onClose,
    String? initialStoryId,
  }) {
    _open(
      context,
      StoryTypes.route,
      onClose: onClose,
      initialStoryId: initialStoryId,
    );
  }

  static void openById(
    BuildContext context, {
    required String storyId,
    VoidCallback? onClose,
  }) {
    _open(
      context,
      StoryTypes.network,
      onClose: onClose,
      initialStoryId: storyId,
    );
  }

  static void openOnboarding(
    BuildContext context, {
    VoidCallback? onClose,
    String? initialStoryId,
  }) {
    _open(
      context,
      StoryTypes.onboarding,
      onClose: onClose,
      initialStoryId: initialStoryId,
    );
  }

  static void _open(
    BuildContext context,
    StoryTypes type, {
    VoidCallback? onClose,
    String? initialStoryId,
  }) {
    final args = StoriesRouteArgs(
      type: type,
      onClose: onClose,
      initialStoryId: initialStoryId,
    );
    const storiesRoute = StoriesRoute();
    final router = GoRouter.of(context);
    if (router.isCurrentRoute(storiesRoute.location)) {
      router.pushReplacement(storiesRoute.location, extra: args);
      return;
    }
    router.push<int?>(storiesRoute.location, extra: args).then((value) {
      if (value != null) {
        StatefulNavigationShell.maybeOf(context)?.goBranch(value);
      }
    });
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final args = state.extra! as StoriesRouteArgs;
    return CustomTransitionPage(
      child: StoriesScreen(
        type: args.type,
        onClose: args.onClose,
        initialStoryId: args.initialStoryId,
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
}

final $storiesRoutes = $appRoutes;

class StoriesRouteArgs {
  final StoryTypes type;
  final VoidCallback? onClose;
  final String? initialStoryId;
  const StoriesRouteArgs({
    required this.type,
    this.onClose,
    this.initialStoryId,
  });
}
