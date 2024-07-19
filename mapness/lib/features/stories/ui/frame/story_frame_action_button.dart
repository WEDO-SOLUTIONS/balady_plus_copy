part of 'story_frame_widget.dart';

class StoryFrameActionButton extends StatefulWidget {
  const StoryFrameActionButton({
    required this.actionTheme,
    required this.action,
    super.key,
  });

  final StoryActionThemeData actionTheme;
  final StoryFrameAction action;

  @override
  State<StoryFrameActionButton> createState() => _StoryFrameActionButtonState();
}

class _StoryFrameActionButtonState extends State<StoryFrameActionButton> {
  String _keyToLocale(AppLocalizations l10n, String key) => switch (key) {
        'try_now' => l10n.tryNow,
        'build_route' => l10n.buildRoute,
        'open_services' => l10n.openServices,
        _ => ''
      };

  String _getActionTitle() {
    final l10n = context.l10n;
    return switch (widget.action) {
      NextStoryAction() => l10n.next,
      NavigationFrameAction(localeKey: final key) => _keyToLocale(l10n, key),
      NetworkLinkFrameAction(title: final title) => title,
    };
  }

  void _onActionPressed(BuildContext context) => switch (widget.action) {
        NextStoryAction() => () {},
        NavigationFrameAction(location: final location) => handleNavigationAction(context, location),
        NetworkLinkFrameAction(url: final url) => handleNetworkLinkAction(url),
      };

  void handleNavigationAction(BuildContext context, String location) {
    final router = GoRouter.of(context);

    if (location.startsWith('/bottomNavBar')) {
      const bottomBarLocations = <int, String>{
        0: '/explore',
        1: '/services',
        2: '/routing',
        3: '/profile',
      };
      for (final entry in bottomBarLocations.entries) {
        if (location.contains(entry.value)) {
          router.pop(entry.key);
          continue;
        }
      }

      if (location.contains('/snap_and_send')) {
        CommonFunctions.openSnapAndSend();
        return;
      }
    }

    router.pushReplacement(location);
  }

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
