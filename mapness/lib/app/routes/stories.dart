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

/// Represents a route for displaying stories.
///
/// Example usage:
/// ```dart
///   StoriesRoute.openOnboarding(context);
///   StoriesRoute.openById(context, storyId: 'storyId');
/// ```
class StoriesRoute extends GoRouteData {
  const StoriesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  /// Opens a route story in the app.
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

  /// Opens a story by ID in the app.
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

  /// Opens the onboarding story in the app.
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

  /// Opens a story in the app.
  static Future<void> _open(
    BuildContext context,
    StoryTypes type, {
    VoidCallback? onClose,
    String? initialStoryId,
  }) async {
    final args = StoriesRouteArgs(
      type: type,
      onClose: onClose,
      initialStoryId: initialStoryId,
    );
    const storiesRoute = StoriesRoute();
    final router = GoRouter.of(context);
    if (router.isCurrentRoute(storiesRoute.location)) {
      await router.pushReplacement(
        storiesRoute.location,
        extra: args,
      );
      return;
    }
    final index = await router.push<int?>(
      storiesRoute.location,
      extra: args,
    );
    if (index != null && context.mounted) {
      /// TODO(scroollocker): We need to rewrite this logic of handling bottom bar navigation
      /// goBranch is not working properly if route was not opened earlier
      const bottomBarLocations = <int, String>{
        0: '/explore',
        1: '/routing',
        2: '/services',
        3: '/profile',
      };

      if (bottomBarLocations.containsKey(index)) {
        context.go(bottomBarLocations[index]!);
        return;
      }
    }
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
      transitionsBuilder: (context, animation, _, child) => SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      ),
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
