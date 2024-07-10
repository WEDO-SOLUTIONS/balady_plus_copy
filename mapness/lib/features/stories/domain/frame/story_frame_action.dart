import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_action.dart';

sealed class StoryFrameAction {
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;
  final double? horizontalPadding;

  StoryFrameAction({
    required this.deeplinkUrl,
    this.textStyle,
    this.backgroundColor,
    this.action,
    this.horizontalPadding,
  });
}

class VerbatimStoryFrameAction extends StoryFrameAction {
  final String title;

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
}

class LocaleKeyFrameAction extends StoryFrameAction {
  final String titleLocaleKey;

  LocaleKeyFrameAction({
    required this.titleLocaleKey,
    required String deeplinkUrl,
    required StoryTextStyle? textStyle,
    Color? backgroundColor,
    StoryAction? action,
    double? horizontalPadding,
  }) : super(
          deeplinkUrl: deeplinkUrl,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          action: action,
          horizontalPadding: horizontalPadding,
        );
}

class DeeplinkStoryFrameAction extends StoryFrameAction {
  DeeplinkStoryFrameAction({required super.deeplinkUrl});
}
