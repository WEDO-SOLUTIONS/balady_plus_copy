import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_texts.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Represents the data for a single frame in a story.
class StoryFrameData {
  /// The ID of the story.
  final String storyId;

  /// The URL of the image associated with the frame.
  /// Can be an asset image or a network image.
  final String? imageUrl;

  /// Indicates whether the image should be displayed in fullscreen mode.
  final bool fullscreenImage;

  /// Indicates whether the frame has been watched by the user.
  final bool isWatched;

  /// Represent the button action for the frame.
  /// Can be a next action, a navigation action, or a network link action.
  final StoryFrameAction? action;

  /// The duration of the story frame in seconds.
  final int duration;

  /// Indicates whether the image is an asset image or a network image.
  final bool? isAssetImage;

  /// The theme data for the network story.
  final NetworkStoryThemeData? networkTheme;

  /// The texts to be displayed in the network story.
  final StoryFrameTexts? networkTexts;

  /// Constructs a [StoryFrameData] object.
  const StoryFrameData({
    required this.storyId,
    this.imageUrl,
    this.action,
    this.duration = 10,
    this.fullscreenImage = true,
    this.isWatched = false,
    this.isAssetImage = false,
    this.networkTheme,
    this.networkTexts,
  });

  /// Creates a copy of this [StoryFrameData] object with the given fields replaced with the new values.
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

  /// Returns the theme for this [StoryFrameData] based on the story ID and the provided color and text themes.
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

  /// Returns the texts for this [StoryFrameData] based on the story ID and the provided localizations.
  StoryFrameTexts textFromId({
    required AppLocalizations l10n,
  }) =>
      networkTexts ?? StoryFrameTexts.fromId(l10n, storyId);
}
