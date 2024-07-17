import 'package:mapness/features/stories/models/story_action.dart';

sealed class StoryFrameAction {
  final String deeplinkUrl;
  final StoryAction? action;

  const StoryFrameAction({
    required this.deeplinkUrl,
    this.action,
  });
}

class VerbatimStoryFrameAction extends StoryFrameAction {
  final String title;

  const VerbatimStoryFrameAction({
    required this.title,
    required super.deeplinkUrl,
    super.action,
  });
}

class LocaleKeyFrameAction extends StoryFrameAction {
  final String titleLocaleKey;

  const LocaleKeyFrameAction({
    required this.titleLocaleKey,
    required super.deeplinkUrl,
    super.action,
  });
}

class DeeplinkStoryFrameAction extends StoryFrameAction {
  DeeplinkStoryFrameAction({required super.deeplinkUrl});
}
