import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/models/story_localization.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryFrameData {
  final String storyId;
  final String? imageUrl;
  final bool fullscreenImage;
  final bool isWatched;
  final StoryFrameAction? action;
  final int duration;
  final bool? isAssetImage;
  final List<Widget> Function(BuildContext context)? additionalContent;
  final NetworkStoryThemeData? networkTheme;
  final StoryFrameTexts? networkTexts;

  const StoryFrameData({
    required this.storyId,
    this.imageUrl,
    this.action,
    this.duration = 10,
    this.fullscreenImage = true,
    this.isWatched = false,
    this.isAssetImage = false,
    this.additionalContent,
    this.networkTheme,
    this.networkTexts,
  });

  StoryFrameData copyWith({
    String? storyId,
    String? imageUrl,
    bool? isWatched,
    StoryFrameAction? action,
    int? duration,
    bool? fullscreenImage,
    bool? isAssetImage,
    Color? closeButtonColor,
  }) =>
      StoryFrameData(
        isAssetImage: isAssetImage ?? this.isAssetImage,
        storyId: storyId ?? this.storyId,
        imageUrl: imageUrl ?? this.imageUrl,
        isWatched: isWatched ?? this.isWatched,
        fullscreenImage: fullscreenImage ?? this.fullscreenImage,
        action: action ?? this.action,
        duration: duration ?? this.duration,
      );

  StoryFrameThemeData themeFromId({
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) {
    final theme = StoryFrameThemeData.fromId(
      storyId,
      colorTheme: colorTheme,
      textTheme: textTheme,
      actionHasGradient: !fullscreenImage,
    );
    return theme.mergeNetworkTheme(networkTheme);
  }

  StoryFrameTexts textFromId({
    required AppLocalizations l10n,
  }) =>
      networkTexts ?? StoryFrameTexts.fromId(l10n, storyId);
}
