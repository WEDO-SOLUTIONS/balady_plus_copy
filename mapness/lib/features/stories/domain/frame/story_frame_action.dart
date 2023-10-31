import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';

class StoryFrameAction {
  final String title;
  final FrameActionType type;
  final String action;
  final StoryTextStyle? textStyle;
  final Color? backgroundColor;

  const StoryFrameAction({
    required this.type,
    required this.action,
    required this.title,
    required this.textStyle,
    required this.backgroundColor,
  });
}

enum FrameActionType {
  callPhone,
  openUrl,
  openDeepLink,
  openMap,
}
