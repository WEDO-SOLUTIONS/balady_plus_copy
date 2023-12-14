import 'package:flutter/material.dart';
import 'package:mapness/_features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/_features/stories/domain/story_action.dart';

class StoryFrameAction {
  final String title;
  final String deeplinkUrl;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;
  final StoryAction? action;

  const StoryFrameAction({
    required this.deeplinkUrl,
    required this.title,
    required this.textStyle,
    required this.backgroundColor,
    this.action,
  });
}
