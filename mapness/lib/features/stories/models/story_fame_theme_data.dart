import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colors/colors_v2/core/base.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';

class StoryFrameThemeData {
  final double horizontalPadding;
  final StoryThumbnailThemeData thumbnailTheme;
  final StoryActionThemeData actionTheme;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final Color backgroundColor;
  final Color? gradientColor;

  StoryFrameThemeData._({
    required this.thumbnailTheme,
    required this.actionTheme,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.backgroundColor,
    this.horizontalPadding = 0,
    this.gradientColor,
  });

  factory StoryFrameThemeData.fromId(
    String id, {
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) {
    final thumbnailTheme = StoryThumbnailThemeData.fromId(
      id,
      colorTheme: colorTheme,
    );
    final actionTheme = StoryActionThemeData.fromId(
      id,
      textTheme: textTheme,
    );
    final baseTheme = StoryFrameThemeData.baseTheme(
      colorTheme: colorTheme,
      textTheme: textTheme,
    ).copyWith(
      thumbnailTheme: thumbnailTheme,
      actionTheme: actionTheme,
    );

    return switch (id) {
      'route1' => baseTheme.copyWith(),
      'route2' => baseTheme.copyWith(),
      'route3' => baseTheme.copyWith(),
      'onboarding1' => baseTheme.copyWith(),
      'onboarding2' => baseTheme.copyWith(
          gradientColor: const Color(0xFFB7C1FB),
        ),
      'onboarding3' => baseTheme.copyWith(),
      _ => baseTheme,
    };
  }

  factory StoryFrameThemeData.baseTheme({
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryFrameThemeData._(
        titleStyle: textTheme.h1SemiBold,
        descriptionStyle: textTheme.bodyLargeRegular,
        backgroundColor: colorTheme.backgroundSurface1,
        horizontalPadding: 16,
        thumbnailTheme: StoryThumbnailThemeData.baseTheme(colorTheme: colorTheme),
        actionTheme: StoryActionThemeData.baseTheme(textTheme: textTheme),
      );

  StoryFrameThemeData copyWith({
    double? horizontalPadding,
    StoryThumbnailThemeData? thumbnailTheme,
    StoryActionThemeData? actionTheme,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? gradientColor,
    Color? backgroundColor,
  }) =>
      StoryFrameThemeData._(
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        thumbnailTheme: thumbnailTheme ?? this.thumbnailTheme,
        actionTheme: actionTheme ?? this.actionTheme,
        titleStyle: titleStyle ?? this.titleStyle,
        descriptionStyle: descriptionStyle ?? this.descriptionStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        gradientColor: gradientColor ?? this.gradientColor,
      );
}

class StoryActionThemeData {
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color textColor;
  final double horizontalPadding;
  const StoryActionThemeData._({
    required this.textStyle,
    required this.backgroundColor,
    required this.textColor,
    required this.horizontalPadding,
  });

  StoryActionThemeData copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    double? horizontalPadding,
    Color? textColor,
  }) =>
      StoryActionThemeData._(
        textStyle: textStyle ?? this.textStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        textColor: textColor ?? this.textColor,
      );

  // TODO: add colors to the theme
  factory StoryActionThemeData.baseTheme({
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryActionThemeData._(
        backgroundColor: BaseColors.extra01,
        horizontalPadding: 24,
        textColor: Colors.white,
        textStyle: textTheme.bodyLargeRegular,
      );

  factory StoryActionThemeData.fromId(
    String id, {
    required ThemeTextStylesV3 textTheme,
  }) {
    final baseTheme = StoryActionThemeData.baseTheme(
      textTheme: textTheme,
    );
    return switch (id) {
      'route1' => baseTheme.copyWith(),
      'route2' => baseTheme.copyWith(),
      'route3' => baseTheme.copyWith(),
      'onboarding1' => baseTheme.copyWith(),
      'onboarding2' => baseTheme.copyWith(),
      'onboarding3' => baseTheme.copyWith(),
      _ => baseTheme,
    };
  }
}

class StoryThumbnailThemeData {
  final Color backgroundColor;
  final Color animationColor;
  final Color closeButtonColor;

  const StoryThumbnailThemeData({
    required this.backgroundColor,
    required this.animationColor,
    required this.closeButtonColor,
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

  factory StoryThumbnailThemeData.baseTheme({
    required AppColorsThemeV2 colorTheme,
  }) =>
      StoryThumbnailThemeData(
        backgroundColor: AppColor.black.withOpacity(0.1),
        animationColor: AppColor.black,
        closeButtonColor: colorTheme.foregroundDisabled,
      );

  factory StoryThumbnailThemeData.fromId(
    String id, {
    required AppColorsThemeV2 colorTheme,
  }) {
    final baseTheme = StoryThumbnailThemeData.baseTheme(
      colorTheme: colorTheme,
    );
    return switch (id) {
      'route1' => baseTheme.copyWith(),
      'route2' => baseTheme.copyWith(),
      'route3' => baseTheme.copyWith(),
      'onboarding1' => baseTheme.copyWith(),
      'onboarding2' => baseTheme.copyWith(),
      'onboarding3' => baseTheme.copyWith(),
      _ => baseTheme,
    };
  }
}
