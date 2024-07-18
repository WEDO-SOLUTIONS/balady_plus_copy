import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_fame_theme_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';

class StoryFrameData {
  final String storyId;
  final String imageUrl;
  final bool isWatched;
  final StoryFrameAction? action;
  final int duration;
  final bool? isAssetImage;
  final List<Widget> Function(BuildContext context, void Function(StoryFrameAction action)? onActionPressed)?
      additionalContent;
  final bool hasGradient;

  const StoryFrameData({
    required this.duration,
    required this.storyId,
    required this.isWatched,
    required this.imageUrl,
    this.action,
    this.isAssetImage = false,
    this.additionalContent,
    this.hasGradient = false,
  });

  StoryFrameData copyWith({
    String? storyId,
    String? imageUrl,
    bool? isWatched,
    StoryFrameAction? action,
    int? duration,
    bool? isAssetImage,
    Color? closeButtonColor,
    bool? hasGradient,
  }) =>
      StoryFrameData(
        isAssetImage: isAssetImage ?? this.isAssetImage,
        storyId: storyId ?? this.storyId,
        imageUrl: imageUrl ?? this.imageUrl,
        isWatched: isWatched ?? this.isWatched,
        action: action ?? this.action,
        duration: duration ?? this.duration,
        hasGradient: hasGradient ?? this.hasGradient,
      );

  StoryFrameThemeData themeFromId({
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryFrameThemeData.fromId(storyId, colorTheme: colorTheme, textTheme: textTheme);
}
