part of 'story_frame_widget.dart';

/// A button widget that represents an action in a story frame.
class StoryFrameActionButton extends StatefulWidget {
  ///  [StoryFrameActionButton].
  const StoryFrameActionButton({
    required this.actionTheme,
    required this.action,
    required this.onNext,
    super.key,
  });

  /// The theme data for the action button.
  final StoryActionThemeData actionTheme;

  /// The action associated with the button.
  final StoryFrameAction action;

  /// The callback function that is called when the next button is pressed.
  final VoidCallback onNext;

  @override
  State<StoryFrameActionButton> createState() => _StoryFrameActionButtonState();
}

class _StoryFrameActionButtonState extends State<StoryFrameActionButton> {
  /// Maps a localization key to its corresponding localized value.
  String _keyToLocale(AppLocalizations l10n, String key) => switch (key) {
        'next' => l10n.next,
        'try_now' => l10n.tryNow,
        'build_route' => l10n.buildRoute,
        'open_services' => l10n.openServices,
        'about_routes' => l10n.onboardingMoreRoutesButton,
        'balady_features' => l10n.onboardingMoreBaladyFeaturesButton,
        'get_started' => l10n.onboardingGetStartedButton,
        _ => ''
      };

  /// Returns the title of the action based on the current widget's action type.
  String _getActionTitle() {
    final l10n = context.l10n;
    return switch (widget.action) {
      NextStoryAction(localeKey: final key, title: final title) => title ?? _keyToLocale(l10n, key),
      NavigationFrameAction(localeKey: final key, title: final title) => title ?? _keyToLocale(l10n, key),
      NetworkLinkFrameAction(title: final title) => title,
    };
  }

  /// Handles the action button press based on the current action type.
  void _onActionPressed(BuildContext context) => switch (widget.action) {
        NextStoryAction() => widget.onNext(),
        NavigationFrameAction(location: final location) => handleNavigationAction(context, location),
        NetworkLinkFrameAction(url: final url) => handleNetworkLinkAction(url),
      };

  /// Handles the navigation action by pushing the specified location to the router.
  void handleNavigationAction(BuildContext context, String location) {
    final router = GoRouter.of(context);
    const bottomBarLocations = <int, String>{
      0: '/explore',
      1: '/routing',
      2: '/services',
      3: '/profile',
    };
    for (final entry in bottomBarLocations.entries) {
      var key = entry.key;
      final direction = Directionality.of(context);
      if (direction == TextDirection.rtl) {
        key = bottomBarLocations.length - 1 - entry.key;
      }
      if (location.contains(entry.value)) {
        router.pop(key);
        return;
      }
    }

    if (location.contains('/snap_and_send')) {
      CommonFunctions.openSnapAndSend();
      return;
    }

    router.pushReplacement(location);
  }

  /// Handles the network link action by opening the specified URL.
  void handleNetworkLinkAction(String url) {
    if (url.startsWith('https://www.joodeskan.sa/')) {
      NavigationService.navigatorKey.currentState?.pushNamed(
        RouteName.jodDonationPage,
      );
      return;
    }
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) => AppButton(
        color: widget.actionTheme.backgroundColor,
        textColor: widget.actionTheme.textColor,
        buttonColorScheme: ButtonColorScheme.primary,
        primaryLabel: _getActionTitle(),
        onTap: () => _onActionPressed(context),
      );
}
