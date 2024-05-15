import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_action.dart';

sealed class StoryFrameAction {
  StoryFrameAction({
    required this.deeplinkUrl,
    required this.textStyle,
    required this.backgroundColor,
    this.action,
  });
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;
}

class VerbatimStoryFrameAction extends StoryFrameAction {
  VerbatimStoryFrameAction({
    required this.title,
    required String deeplinkUrl,
    required StoryTextStyle textStyle,
    Color? backgroundColor,
    StoryAction? action,
  }) : super(
          deeplinkUrl: deeplinkUrl,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          action: action,
        );
  final String title;
}

class LocaleKeyFrameAction extends StoryFrameAction {
  LocaleKeyFrameAction({
    required this.titleLocaleKey,
    required String deeplinkUrl,
    required StoryTextStyle textStyle,
    Color? backgroundColor,
    StoryAction? action,
  }) : super(
          deeplinkUrl: deeplinkUrl,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          action: action,
        );
  final String titleLocaleKey;
}
