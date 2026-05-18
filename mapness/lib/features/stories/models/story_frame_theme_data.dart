import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colors/colors_v2/core/base.dart';
import 'package:flutter/material.dart';

/// Represents the theme data for a story frame.
class StoryFrameThemeData {
  final StoryActionThemeData actionTheme;
  final StoryCloseButtonThemeData closeButtonTheme;
  final StoryTrackThemeData trackTheme;
  final EdgeInsets titlePadding;
  final EdgeInsets descriptionPadding;
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
    required this.titlePadding,
    required this.descriptionPadding,
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

    final baseTheme = StoryFrameThemeData.baseTheme(
      colorTheme: colorTheme,
      textTheme: textTheme,
    ).copyWith(
      actionTheme: actionTheme,
    );

    final onboardingTheme = baseTheme.copyWith(
      titleStyle: textTheme.h2SemiBold.copyWith(
        color: AppColor.black,
        fontSize: 26,
      ),
      descriptionStyle: textTheme.bodyLargeRegular.copyWith(
        color: AppColor.black,
        fontSize: 14,
      ),
      actionTheme: actionTheme.copyWith(
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF003449),
      ),
    );

    final saudiDayTheme = baseTheme.copyWith(
      titleStyle: textTheme.h2SemiBold.copyWith(
        color: AppColor.white,
      ),
      actionTheme: actionTheme.copyWith(
        textColor: AppColor.black,
        backgroundColor: AppColor.white,
      ),
      titlePadding: const EdgeInsets.symmetric(
        horizontal: Spacing.$2x,
        vertical: Spacing.$8x,
      ),
    );

    return switch (id) {
      'onboarding1' => onboardingTheme,
      'onboarding2' => onboardingTheme,
      'onboarding3' => onboardingTheme,
      'saudiDay' => saudiDayTheme,
      _ => baseTheme,
    };
  }

  /// Creates a base [StoryFrameThemeData] instance.
  factory StoryFrameThemeData.baseTheme({
    /// Its not used in the current implementation.
    /// But if you need to get color from the theme, you can use this parameter.
    // ignore: avoid_unused_constructor_parameters
    required AppColorsThemeV2 colorTheme,
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryFrameThemeData._(
        titleStyle: textTheme.h1SemiBold.copyWith(
          color: AppColor.white,
        ),
        descriptionStyle: textTheme.bodyLargeRegular.copyWith(
          color: AppColor.white,
        ),
        backgroundColor: AppColor.black,
        titlePadding: const EdgeInsets.symmetric(horizontal: 35),
        descriptionPadding: const EdgeInsets.only(
          left: 35,
          right: 18,
        ),
        actionTheme: StoryActionThemeData.baseTheme(textTheme: textTheme),
        closeButtonTheme: StoryCloseButtonThemeData.baseTheme(),
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
    StoryActionThemeData? actionTheme,
    StoryCloseButtonThemeData? closeButtonTheme,
    StoryTrackThemeData? trackTheme,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? gradientColor,
    Color? backgroundColor,
    EdgeInsets? titlePadding,
    EdgeInsets? descriptionPadding,
  }) =>
      StoryFrameThemeData._(
        titlePadding: titlePadding ?? this.titlePadding,
        descriptionPadding: descriptionPadding ?? this.descriptionPadding,
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
  final EdgeInsets padding;
  final bool hasGradient;

  const StoryActionThemeData._({
    required this.textStyle,
    required this.backgroundColor,
    required this.textColor,
    required this.padding,
    this.hasGradient = true,
  });

  /// Creates a copy of the [StoryActionThemeData] instance with the provided properties.
  StoryActionThemeData copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    EdgeInsets? padding,
    Color? textColor,
    bool? hasGradient,
  }) =>
      StoryActionThemeData._(
        textStyle: textStyle ?? this.textStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        padding: padding ?? this.padding,
        textColor: textColor ?? this.textColor,
        hasGradient: hasGradient ?? this.hasGradient,
      );

  /// Creates a base [StoryActionThemeData] instance.
  factory StoryActionThemeData.baseTheme({
    required ThemeTextStylesV3 textTheme,
  }) =>
      StoryActionThemeData._(
        backgroundColor: BaseColors.extra01,
        padding: const EdgeInsets.all(Spacing.$6x),
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

/// Represents the theme data for a story close button.
class StoryCloseButtonThemeData {
  final Color iconColor;
  final Color backgroundColor;

  const StoryCloseButtonThemeData({
    required this.backgroundColor,
    required this.iconColor,
  });

  /// Creates a copy of the [StoryCloseButtonThemeData] instance with the provided properties.
  StoryCloseButtonThemeData copyWith({
    Color? backgroundColor,
    Color? iconColor,
  }) =>
      StoryCloseButtonThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        iconColor: iconColor ?? this.iconColor,
      );

  /// Creates a base [StoryCloseButtonThemeData] instance.
  factory StoryCloseButtonThemeData.baseTheme() => StoryCloseButtonThemeData(
        iconColor: AppColor.white,
        backgroundColor: AppColor.white.withOpacity(0.06),
      );

  /// Creates a [StoryCloseButtonThemeData] instance based on the provided ID.
  /// Its not used in the current implementation.
  /// But if you neet to specify a theme for a specific story, you can use this method.
  factory StoryCloseButtonThemeData.fromId(String id) {
    final baseTheme = StoryCloseButtonThemeData.baseTheme();

    return switch (id) {
      'onboarding1' => baseTheme,
      'onboarding2' => baseTheme,
      'onboarding3' => baseTheme,
      _ => baseTheme,
    };
  }
}

/// Represents the theme data for a story track.
class StoryTrackThemeData {
  final Color color;
  final Color backgroundColor;

  const StoryTrackThemeData({
    required this.backgroundColor,
    required this.color,
  });

  /// Creates a copy of the [StoryTrackThemeData] instance with the provided properties.
  StoryTrackThemeData copyWith({
    Color? backgroundColor,
    Color? color,
  }) =>
      StoryTrackThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        color: color ?? this.color,
      );

  /// Creates a base [StoryTrackThemeData] instance.
  factory StoryTrackThemeData.baseTheme() => StoryTrackThemeData(
        color: AppColor.white,
        backgroundColor: AppColor.white.withOpacity(0.1),
      );

  /// Creates a [StoryTrackThemeData] instance based on the provided ID.
  /// Its not used in the current implementation.
  /// But if you neet to specify a theme for a specific story, you can use this method.
  factory StoryTrackThemeData.fromId(String id) {
    final baseTheme = StoryTrackThemeData.baseTheme();
    return switch (id) {
      'onboarding1' => baseTheme,
      'onboarding2' => baseTheme,
      'onboarding3' => baseTheme,
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
