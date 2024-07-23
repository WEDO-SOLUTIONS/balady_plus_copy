import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colors/colors_v2/core/base.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';

/// Represents the theme data for a story frame.
class StoryFrameThemeData {
  final double horizontalPadding;
  final StoryActionThemeData actionTheme;
  final StoryCloseButtonThemeData closeButtonTheme;
  final StoryTrackThemeData trackTheme;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final Color backgroundColor;
  final Color? gradientColor;

  const StoryFrameThemeData._({
    required this.actionTheme,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.backgroundColor,
    required this.closeButtonTheme,
    required this.trackTheme,
    this.horizontalPadding = 0,
    this.gradientColor,
  });

  /// Creates a [StoryFrameThemeData] instance based on the provided ID.
  factory StoryFrameThemeData.fromId(
    String id, {
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
    bool actionHasGradient = false,
  }) {
    final actionTheme = StoryActionThemeData.fromId(
      id,
      textTheme: textTheme,
    ).copyWith(
      hasGradient: actionHasGradient,
    );
    final closeButtonTheme = StoryCloseButtonThemeData.fromId(
      id,
      colorTheme: colorTheme,
    );
    final trackTheme = StoryTrackThemeData.fromId(id);

    final baseTheme = StoryFrameThemeData.baseTheme(
      colorTheme: colorTheme,
      textTheme: textTheme,
    ).copyWith(
      actionTheme: actionTheme,
      closeButtonTheme: closeButtonTheme,
      trackTheme: trackTheme,
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

  /// Creates a base [StoryFrameThemeData] instance.
  factory StoryFrameThemeData.baseTheme({
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryFrameThemeData._(
        titleStyle: textTheme.h1SemiBold,
        descriptionStyle: textTheme.bodyLargeRegular,
        backgroundColor: colorTheme.backgroundSurface1,
        horizontalPadding: 16,
        actionTheme: StoryActionThemeData.baseTheme(textTheme: textTheme),
        closeButtonTheme: StoryCloseButtonThemeData.baseTheme(colorTheme: colorTheme),
        trackTheme: StoryTrackThemeData.baseTheme(),
      );

  /// Merges the network theme data with the current [StoryFrameThemeData].
  StoryFrameThemeData mergeNetworkTheme(NetworkStoryThemeData? networkTheme) {
    if (networkTheme == null) {
      return this;
    }
    return copyWith(
      titleStyle: titleStyle.copyWith(color: networkTheme.titleColor),
      descriptionStyle: descriptionStyle.copyWith(color: networkTheme.descriptionColor),
      actionTheme: actionTheme.copyWith(
        backgroundColor: networkTheme.actionbackgroundColor,
        textColor: networkTheme.actionTextColor,
      ),
    );
  }

  /// Creates a copy of the [StoryFrameThemeData] instance with the provided properties.
  StoryFrameThemeData copyWith({
    double? horizontalPadding,
    StoryActionThemeData? actionTheme,
    StoryCloseButtonThemeData? closeButtonTheme,
    StoryTrackThemeData? trackTheme,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? gradientColor,
    Color? backgroundColor,
  }) =>
      StoryFrameThemeData._(
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        actionTheme: actionTheme ?? this.actionTheme,
        closeButtonTheme: closeButtonTheme ?? this.closeButtonTheme,
        trackTheme: trackTheme ?? this.trackTheme,
        titleStyle: titleStyle ?? this.titleStyle,
        descriptionStyle: descriptionStyle ?? this.descriptionStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        gradientColor: gradientColor ?? this.gradientColor,
      );
}

/// Represents the theme data for a story action.
class StoryActionThemeData {
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color textColor;
  final double horizontalPadding;
  final bool hasGradient;

  const StoryActionThemeData._({
    required this.textStyle,
    required this.backgroundColor,
    required this.textColor,
    required this.horizontalPadding,
    this.hasGradient = true,
  });

  /// Creates a copy of the [StoryActionThemeData] instance with the provided properties.
  StoryActionThemeData copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    double? horizontalPadding,
    Color? textColor,
    bool? hasGradient,
  }) =>
      StoryActionThemeData._(
        textStyle: textStyle ?? this.textStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        textColor: textColor ?? this.textColor,
        hasGradient: hasGradient ?? this.hasGradient,
      );

  /// Creates a base [StoryActionThemeData] instance.
  factory StoryActionThemeData.baseTheme({
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryActionThemeData._(
        backgroundColor: BaseColors.extra01,
        horizontalPadding: 24,
        textColor: Colors.white,
        textStyle: textTheme.bodyLargeRegular,
      );

  /// Creates a [StoryActionThemeData] instance based on the provided ID.
  factory StoryActionThemeData.fromId(
    String id, {
    required ThemeTextStylesV3 textTheme,
  }) {
    final baseTheme = StoryActionThemeData.baseTheme(
      textTheme: textTheme,
    );
    final onboardingTheme = baseTheme.copyWith(
      backgroundColor: AppColor.white,
      textColor: AppColor.black,
    );
    final routeTheme = baseTheme.copyWith(
      backgroundColor: NonThemeColor.color29,
      textColor: AppColor.white,
    );
    return switch (id) {
      'route1' => routeTheme,
      'route2' => routeTheme,
      'route3' => routeTheme,
      'onboarding1' => onboardingTheme,
      'onboarding2' => onboardingTheme,
      'onboarding3' => onboardingTheme,
      _ => baseTheme,
    };
  }
}

/// Represents the theme data for a story thumbnail.
class StoryCloseButtonThemeData {
  final Color iconColor;
  final Color backgroundColor;

  const StoryCloseButtonThemeData({
    required this.backgroundColor,
    required this.iconColor,
  });

  /// Creates a copy of the [StoryThumbnailThemeData] instance with the provided properties.
  StoryCloseButtonThemeData copyWith({
    Color? backgroundColor,
    Color? iconColor,
  }) =>
      StoryCloseButtonThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        iconColor: iconColor ?? this.iconColor,
      );

  /// Creates a base [StoryThumbnailThemeData] instance.
  factory StoryCloseButtonThemeData.baseTheme({
    required AppColorsThemeV2 colorTheme,
  }) =>
      StoryCloseButtonThemeData(
        backgroundColor: colorTheme.backgroundDisabled,
        iconColor: AppColor.black,
      );

  /// Creates a [StoryThumbnailThemeData] instance based on the provided ID.
  factory StoryCloseButtonThemeData.fromId(
    String id, {
    required AppColorsThemeV2 colorTheme,
  }) {
    final baseTheme = StoryCloseButtonThemeData.baseTheme(
      colorTheme: colorTheme,
    );
    final routeTheme = baseTheme.copyWith(
      iconColor: AppColor.white,
      backgroundColor: AppColor.white.withOpacity(0.06),
    );
    return switch (id) {
      'route1' => routeTheme,
      'route2' => routeTheme,
      'route3' => routeTheme,
      _ => baseTheme,
    };
  }
}

/// Represents the theme data for a story thumbnail.
class StoryTrackThemeData {
  final Color color;
  final Color backgroundColor;

  const StoryTrackThemeData({
    required this.backgroundColor,
    required this.color,
  });

  /// Creates a copy of the [StoryThumbnailThemeData] instance with the provided properties.
  StoryTrackThemeData copyWith({
    Color? backgroundColor,
    Color? color,
  }) =>
      StoryTrackThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        color: color ?? this.color,
      );

  /// Creates a base [StoryThumbnailThemeData] instance.
  factory StoryTrackThemeData.baseTheme() => StoryTrackThemeData(
        backgroundColor: AppColor.black.withOpacity(0.1),
        color: AppColor.black,
      );

  /// Creates a [StoryThumbnailThemeData] instance based on the provided ID.
  factory StoryTrackThemeData.fromId(String id) {
    final baseTheme = StoryTrackThemeData.baseTheme();
    final routeTheme = baseTheme.copyWith(
      color: AppColor.white,
      backgroundColor: AppColor.white.withOpacity(0.1),
    );
    return switch (id) {
      'route1' => routeTheme,
      'route2' => routeTheme,
      'route3' => routeTheme,
      _ => baseTheme,
    };
  }
}

/// Represents the theme data for a network story.
class NetworkStoryThemeData {
  final Color? titleColor;
  final Color? descriptionColor;
  final Color? actionbackgroundColor;
  final Color? actionTextColor;

  const NetworkStoryThemeData({
    this.titleColor,
    this.descriptionColor,
    this.actionbackgroundColor,
    this.actionTextColor,
  });
}
