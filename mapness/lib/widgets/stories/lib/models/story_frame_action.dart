import 'package:flutter/material.dart';
import 'package:mapness/widgets/stories/lib/models/story_action.dart';
import 'package:mapness/widgets/stories/lib/models/story_text_style.dart';

sealed class StoryFrameAction {
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;
  final double? horizontalPadding;

  const StoryFrameAction({
    required this.deeplinkUrl,
    this.textStyle,
    this.backgroundColor,
    this.action,
    this.horizontalPadding,
  });
}

class VerbatimStoryFrameAction extends StoryFrameAction {
  final String title;

  const VerbatimStoryFrameAction({
    required this.title,
    required super.deeplinkUrl,
    required super.textStyle,
    super.backgroundColor,
    super.action,
  });
}

class LocaleKeyFrameAction extends StoryFrameAction {
  final String titleLocaleKey;

  const LocaleKeyFrameAction({
    required this.titleLocaleKey,
    required super.deeplinkUrl,
    required super.textStyle,
    super.backgroundColor,
    super.action,
    super.horizontalPadding,
  });
}

class DeeplinkStoryFrameAction extends StoryFrameAction {
  DeeplinkStoryFrameAction({required super.deeplinkUrl});
}
