import 'package:flutter/material.dart';
import 'package:mapness/_features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/_features/stories/domain/story_action.dart';

class StoryFrameAction {
  const StoryFrameAction({
    required this.deeplinkUrl,
    required this.title,
    required this.textStyle,
    required this.backgroundColor,
    this.action,
    this.localeTitle,
  });
  final String title;
  final String? localeTitle;
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;
}
