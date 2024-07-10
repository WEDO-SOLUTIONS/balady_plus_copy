import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/domain/story_types.dart';
import 'package:mapness/features/stories/presentation/frame/dismissible_overlay.dart';
import 'package:mapness/features/stories/presentation/stories_fullscreen.dart';
import 'package:mapness/features/stories/presentation/story_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper/locale_helper.dart';

class Stories {
  static OverlayEntry? _overlayEntry;
  static final GlobalKey<DismissibleTransitionState> _transitionState = GlobalKey();

  static void close() {
    _transitionState.currentState?.dismiss();
  }

  static bool get isShowing => _overlayEntry != null;

  static void hide() {
    _hide();
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
            child: Theme(
              data: Theme.of(context),
              child: Consumer(
                builder: (context, ref, child) => DismissibleTransition(
                  key: _transitionState,
                  onDismiss: () {
                    ref.read(storyServiceProvider.notifier).resumeUpdate();
                    _hide();
                  },
                  child: storyWidget,
                ),
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
    void handleDeeplink(String url) {
      if (url.startsWith('/')) {
        router.push(url);
      } else if (url.startsWith('https://www.joodeskan.sa/')) {
        NavigationService.navigatorKey.currentState?.pushNamed(
          RouteName.jodDonationPage,
        );
      } else {
        launchUrl(Uri.parse(url));
      }
    }

    final storyWidget = StoryLocalization(
      l10n: context.l10n,
      child: StoriesFullscreen.story(
        onClose: () => _transitionState.currentState?.dismiss(),
        initialStoryId: id,
        handleDeeplink: handleDeeplink,
      ),
    );

    showStory(context, storyWidget);
  }

  static void showOnboarding(
    BuildContext context,
    StoryTypes type,
    String id, {
    VoidCallback? onClose,
    bool? onActionShowNextHistory,
    StatefulNavigationShell? navigationShell,
  }) {
    void handleDeeplink(String url) {
      const pageTitle = {
        0: 'profile',
        1: 'services',
        2: 'route',
        3: 'explore',
      };

      final router = GoRouter.of(rootNavigatorKey.currentContext!);

      if (url.startsWith('/bottomNavBar')) {
        pageTitle.map((key, value) {
          if (url.contains(value)) {
            navigationShell?.goBranch(key);
            if (url.contains('/snap_and_send')) {
              CommonFunctions.openSnapAndSend();
            }
          }
          return MapEntry(key, value);
        });
      } else {
        router.push(url);
      }
    }

    final storyWidget = StoryLocalization(
      l10n: context.l10n,
      child: StoriesFullscreen.onboadring(
        localStoryType: type,
        initialStoryId: id,
        onClose: () {
          _transitionState.currentState?.dismiss();
          onClose?.call();
        },
        onActionShowNextHistory: onActionShowNextHistory,
        handleDeeplink: handleDeeplink,
      ),
    );

    showStory(context, storyWidget);
  }
}
