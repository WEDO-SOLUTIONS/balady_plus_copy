part of 'story_frame_widget.dart';

const _joodeskanPattern = 'https://www.joodeskan.sa/';

/// A button widget that represents an action in a story frame.
class StoryFrameActionButton extends ConsumerStatefulWidget {
  ///  [StoryFrameActionButton].
  const StoryFrameActionButton({
    required this.actionTheme,
    required this.action,
    required this.onNext,
    this.onActionPressed,
    this.actionColor,
    super.key,
  });

  /// The theme data for the action button.
  final StoryActionThemeData actionTheme;

  /// The action associated with the button.
  final StoryFrameAction action;

  /// The callback function that is called when the next button is pressed.
  final VoidCallback onNext;

  /// Additional event called when the button is pressed.
  final VoidCallback? onActionPressed;

  final Color? actionColor;

  @override
  ConsumerState<StoryFrameActionButton> createState() => _StoryFrameActionButtonState();
}

class _StoryFrameActionButtonState extends ConsumerState<StoryFrameActionButton> {
  /// Maps a localization key to its corresponding localized value.
  String _keyToLocale(AppLocalizations l10n, String key) => switch (key) {
    'next' => l10n.next,
    'try_now' => l10n.tryNow,
    'build_route' => l10n.buildRoute,
    'open_services' => l10n.openServices,
    'about_routes' => l10n.onboardingMoreRoutesButton,
    'balady_features' => l10n.onboardingMoreBaladyFeaturesButton,
    // TODO: After release delete from localizy [onboardingGetStartedButton] key
    // It was previously used instead of "onboarding3Action"
    'onboarding3Action' => l10n.onboarding3Action,
    'saudiDayAction' => l10n.saudiDayAction,
    _ => '',
  };

  /// Returns the title of the action based on the current widget's action type.
  String _getActionTitle() {
    final l10n = context.l10n;
    return switch (widget.action) {
      NextStoryAction(localeKey: final key, title: final title) ||
      NavigationFrameAction(
        localeKey: final key,
        title: final title,
      ) => title == null || title.isEmpty ? _keyToLocale(l10n, key) : title,
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
    if (location.contains('/snap_and_send')) {
      CommonFunctions.openSnapAndSend();
      return;
    }

    if (context.router.canPop()) {
      context.router.pop();
    }

    context.router.navigatePath(location);
  }

  /// Handles the network link action by opening the specified URL.
  void handleNetworkLinkAction(String url) {
    final Uri uri = Uri.parse(url);
    if (url.startsWith(_joodeskanPattern)) {
      NavigationService.navigatorKey.currentState?.pushNamed(
        RouteName.jodDonationPage,
      );
      return;
    } else if (url.contains('/miniApps')) {
      final urlParams = uri.fragment.isNotEmpty ? Uri.parse(uri.fragment) : uri;
      final params = urlParams.queryParameters;
      if (params['groupId'] != null) {
        CommonFunctions.openMiniAppGroupId(
          groupId: params['groupId'].toString(),
        );
      } else if (params['key'] != null) {
        CommonFunctions.openMiniApp(serviceKey: params['key'].toString());
      }
      final AppRouter router = ref.read(appRouterProvider)..push(MapnessServicesRoute());
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.$4x),
    child: FractionallySizedBox(
      widthFactor: .82,
      child: AppButton(
        color: widget.actionColor,
        buttonColorScheme: ButtonColorScheme.accent,
        primaryLabel: _getActionTitle(),
        onTap: () {
          widget.onActionPressed?.call();
          _onActionPressed(context);
        },
      ),
    ),
  );
}
