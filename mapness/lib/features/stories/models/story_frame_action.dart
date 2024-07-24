/// Represents a sealed class for different types of actions that can be performed on a story frame.
sealed class StoryFrameAction {
  const StoryFrameAction();
}

/// Network link frame action.
///
/// This action is used to open a network link.
class NetworkLinkFrameAction extends StoryFrameAction {
  final String title;
  final String url;

  const NetworkLinkFrameAction({
    required this.title,
    required this.url,
  });
}

/// Nvigation frame action.
///
/// Title is a locale key that should be used to get the title from the localization.
/// This action is used to navigate to a specific location using [location].
class NavigationFrameAction extends StoryFrameAction {
  final String? title;
  final String localeKey;
  final String location;

  const NavigationFrameAction({
    required this.location,
    required this.localeKey,
    this.title,
  });
}

/// This action is used to navigate to the next story.
///
/// The [localeKey] parameter is an optional locale key that can be used for localization.
/// By default the title is 'Next'.

class NextStoryAction extends StoryFrameAction {
  final String localeKey;
  final String? title;

  const NextStoryAction({
    this.localeKey = 'next',
    this.title,
  });
}
