import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/stories/domain/story_types.dart';
import 'package:mapness/_features/stories/presentation/frame/dismissible_overlay.dart';
import 'package:mapness/_features/stories/presentation/stories_fullscreen.dart';
import 'package:mapness/_features/stories/presentation/stories_onboarding.dart';
import 'package:mapness/_features/stories/presentation/story_localizations.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class Stories {
  static OverlayEntry? _overlayEntry;
  static final GlobalKey<DismissibleTransitionState> _transitionState =
      GlobalKey();

  static void close() {
    _transitionState.currentState?.dismiss();
  }

  static void _hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void showStory(BuildContext context, Widget storyWidget) {
    _overlayEntry = OverlayEntry(
      builder: (_) => StoryLocalizations(
        locale: context.l10n,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: Theme(
              data: Theme.of(context),
              child: DismissibleTransition(
                key: _transitionState,
                onDismiss: _hide,
                child: storyWidget,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  static void showStoryById(BuildContext context, String id) {
    final router = GoRouter.of(rootNavigatorKey.currentContext!);
    final storyWidget = StoriesFullscreen(
      onClose: () => _transitionState.currentState?.dismiss(),
      initialStoryId: id,
      handleDeeplink: (url) {
        if (url.startsWith('/')) {
          router.push(url);
        }
        launchUrl(Uri.parse(url));
      },
    );

    showStory(context, storyWidget);
  }

  static void showOnboarding(BuildContext context, StoryTypes type, String id,
      {VoidCallback? onClose}) {
    final storyWidget = StoriesOnboarding(
      type: type,
      initialStoryId: id,
      onClose: () {
        _transitionState.currentState?.dismiss();
        onClose?.call();
      },
    );

    showStory(context, storyWidget);
  }
}
