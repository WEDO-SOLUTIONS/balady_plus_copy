import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colors/colors_v2/core/base.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';

class StoryThemeData {
  final double horizontalPadding;
  final StoryThumbnailThemeData? thumbnailThemeData;
  final StoryActionThemeData? storyActionThemeData;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  StoryThemeData._({
    this.thumbnailThemeData,
    this.storyActionThemeData,
    this.titleStyle,
    this.descriptionStyle,
    this.horizontalPadding = 0,
  });

  factory StoryThemeData.typedFromTheme(
    StoryTypes type, {
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) =>
      switch (type) {
        // TODO(ilyasov): add colors to the theme
        StoryTypes.onboarding => StoryThemeData._(
            horizontalPadding: 16,
            thumbnailThemeData: StoryThumbnailThemeData(
              backgroundColor: AppColor.black.withOpacity(0.1),
              animationColor: AppColor.black,
              closeButtonColor: colorTheme.foregroundDisabled,
            ),
            titleStyle: textTheme.h1SemiBold,
            descriptionStyle: textTheme.bodyLargeRegular,
            storyActionThemeData: const StoryActionThemeData(
              backgroundColor: BaseColors.extra01,
              horizontalPadding: 24,
              textColor: Colors.white,
            ),
          ),
        StoryTypes.route => StoryThemeData._(
            horizontalPadding: 35,
            titleStyle: textTheme.h2SemiBold,
            descriptionStyle: textTheme.bodyLargeRegular,
            storyActionThemeData: const StoryActionThemeData(
              backgroundColor: NonThemeColor.color29,
              horizontalPadding: 24,
              textColor: Colors.white,
            ),
          )
      };

  StoryThemeData copyWith({
    double? horizontalPadding,
    StoryThumbnailThemeData? thumbnailThemeData,
    StoryActionThemeData? storyActionThemeData,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
  }) =>
      StoryThemeData._(
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        thumbnailThemeData: thumbnailThemeData ?? this.thumbnailThemeData,
        storyActionThemeData: storyActionThemeData ?? this.storyActionThemeData,
        titleStyle: titleStyle ?? this.titleStyle,
        descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      );
}

class StoryActionThemeData {
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final double? horizontalPadding;
  const StoryActionThemeData({
    this.textStyle,
    this.backgroundColor,
    this.textColor,
    this.horizontalPadding,
  });

  StoryActionThemeData copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    double? horizontalPadding,
    Color? textColor,
  }) =>
      StoryActionThemeData(
        textStyle: textStyle ?? this.textStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        textColor: textColor ?? this.textColor,
      );
}

class StoryThumbnailThemeData {
  final Color? backgroundColor;
  final Color? animationColor;
  final Color? closeButtonColor;

  const StoryThumbnailThemeData({
    this.backgroundColor,
    this.animationColor,
    this.closeButtonColor,
  });

  StoryThumbnailThemeData copyWith({
    Color? backgroundColor,
    Color? animationColor,
    Color? closeButtonColor,
  }) =>
      StoryThumbnailThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        animationColor: animationColor ?? this.animationColor,
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      );
}
