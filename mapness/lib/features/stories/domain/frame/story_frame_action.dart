import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_action.dart';

sealed class StoryFrameAction {
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;
  final double? horizontalPadding;
  final double? verticalPadding;

  const StoryFrameAction({
    required this.deeplinkUrl,
    this.textStyle,
    this.backgroundColor,
    this.action,
    this.horizontalPadding,
    this.verticalPadding,
  });
}

class VerbatimStoryFrameAction extends StoryFrameAction {
  final String title;

  const VerbatimStoryFrameAction({
    required this.title,
    required String deeplinkUrl,
    required StoryTextStyle textStyle,
    Color? backgroundColor,
    StoryAction? action,
    double? verticalPadding,
  }) : super(
          deeplinkUrl: deeplinkUrl,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          action: action,
          verticalPadding: verticalPadding,
        );
}

class LocaleKeyFrameAction extends StoryFrameAction {
  final String titleLocaleKey;

  const LocaleKeyFrameAction({
    required this.titleLocaleKey,
    required String deeplinkUrl,
    required StoryTextStyle? textStyle,
    Color? backgroundColor,
    StoryAction? action,
    double? horizontalPadding,
    double? verticalPadding,
  }) : super(
          deeplinkUrl: deeplinkUrl,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          action: action,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
        );
}

class DeeplinkStoryFrameAction extends StoryFrameAction {
  const DeeplinkStoryFrameAction({required super.deeplinkUrl});
}
