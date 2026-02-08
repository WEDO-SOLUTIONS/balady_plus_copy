import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/material.dart';

const _regular = FontWeight.w400;
const _medium = FontWeight.w500;
const _semiBold = FontWeight.w600;

/// V3 because it is the third version of the text styles
///
/// !!! Don't forget to add it to extensions to your theme !!!
class ThemeTextStylesV3 extends ThemeExtension<ThemeTextStylesV3> {
  /// -- HEADING --

  ///Size:30 Weight:600 LH: 36 LS: 0
  final TextStyle h1SemiBold;

  ///Size:30 Weight:500 LH: 36 LS: 0
  final TextStyle h1Medium;

  ///Size:24 Weight:600 LH: 30 LS: 0
  final TextStyle h2SemiBold;

  ///Size:24 Weight:500 LH: 30 LS: 0
  final TextStyle h2Medium;

  ///Size:20 Weight:600 LH: 24 LS: 0
  final TextStyle h3SemiBold;

  ///Size:20 Weight:500 LH: 24 LS: 0
  final TextStyle h3Medium;

  ///Size:18 Weight:600 LH: 24 LS: 0
  final TextStyle h4SemiBold;

  ///Size:18 Weight:500 LH: 24 LS: 0
  final TextStyle h4Medium;

  /// -- Body --

  ///Size:16 Weight:600 LH: 20 LS: 0
  final TextStyle bodyLargeSemiBold;

  ///Size:16 Weight:500 LH: 20 LS: 0
  final TextStyle bodyLargeMedium;

  ///Size:16 Weight:400 LH: 20 LS: 0
  final TextStyle bodyLargeRegular;

  ///Size:14 Weight:600 LH: 18 LS: 0
  final TextStyle bodySmallSemiBold;

  ///Size:14 Weight:500 LH: 18 LS: 0
  final TextStyle bodySmallMedium;

  ///Size:14 Weight:400 LH: 18 LS: 0
  final TextStyle bodySmallRegular;

  /// -- CAPTION --

  ///Size:13 Weight:600 LH: 16 LS: 0
  final TextStyle captionLargeSemiBold;

  ///Size:13 Weight:500 LH: 16 LS: 0
  final TextStyle captionLargeMedium;

  ///Size:13 Weight:400 LH: 16 LS: 0
  final TextStyle captionLargeRegular;

  ///Size:12 Weight:600 LH: 16 LS: 0
  final TextStyle captionMediumSemiBold;

  ///Size:12 Weight:500 LH: 16 LS: 0
  final TextStyle captionMediumMedium;

  ///Size:12 Weight:400 LH: 16 LS: 0
  final TextStyle captionMediumRegular;

  ///Size:14 Weight:600 LH: 14 LS: 0
  final TextStyle captionSmallSemiBold;

  ///Size:11 Weight:500 LH: 14 LS: 0
  final TextStyle captionSmallMedium;

  ///Size:14 Weight:400 LH: 14 LS: 0
  final TextStyle captionSmallRegular;

  /// --- Buttons ---

  ///Size:16 Weight:600 LH: 24 LS: 0
  final TextStyle buttonL;

  ///Size:14 Weight:600 LH: 20 LS: 0
  final TextStyle buttonM;

  ThemeTextStylesV3({
    required this.h1SemiBold,
    required this.h1Medium,
    required this.h2SemiBold,
    required this.h2Medium,
    required this.h3SemiBold,
    required this.h3Medium,
    required this.h4SemiBold,
    required this.h4Medium,
    required this.bodyLargeSemiBold,
    required this.bodyLargeMedium,
    required this.bodyLargeRegular,
    required this.bodySmallSemiBold,
    required this.bodySmallMedium,
    required this.bodySmallRegular,
    required this.captionLargeSemiBold,
    required this.captionLargeMedium,
    required this.captionLargeRegular,
    required this.captionMediumSemiBold,
    required this.captionMediumMedium,
    required this.captionMediumRegular,
    required this.captionSmallSemiBold,
    required this.captionSmallMedium,
    required this.captionSmallRegular,
    required this.buttonL,
    required this.buttonM,
  });

  @override
  ThemeExtension<ThemeTextStylesV3> copyWith({
    TextStyle? h1SemiBold,
    TextStyle? h1Medium,
    TextStyle? h2SemiBold,
    TextStyle? h2Medium,
    TextStyle? h3SemiBold,
    TextStyle? h3Medium,
    TextStyle? h4SemiBold,
    TextStyle? h4Medium,
    TextStyle? bodyLargeSemiBold,
    TextStyle? bodyLargeMedium,
    TextStyle? bodyLargeRegular,
    TextStyle? bodySmallSemiBold,
    TextStyle? bodySmallMedium,
    TextStyle? bodySmallRegular,
    TextStyle? captionLargeSemiBold,
    TextStyle? captionLargeMedium,
    TextStyle? captionLargeRegular,
    TextStyle? captionMediumSemiBold,
    TextStyle? captionMediumMedium,
    TextStyle? captionMediumRegular,
    TextStyle? captionSmallSemiBold,
    TextStyle? captionSmallMedium,
    TextStyle? captionSmallRegular,
    TextStyle? buttonL,
    TextStyle? buttonM,
  }) =>
      ThemeTextStylesV3(
        h1SemiBold: h1SemiBold ?? this.h1SemiBold,
        h1Medium: h1Medium ?? this.h1Medium,
        h2SemiBold: h2SemiBold ?? this.h2SemiBold,
        h2Medium: h2Medium ?? this.h2Medium,
        h3SemiBold: h3SemiBold ?? this.h3SemiBold,
        h3Medium: h3Medium ?? this.h3Medium,
        h4SemiBold: h4SemiBold ?? this.h4SemiBold,
        h4Medium: h4Medium ?? this.h4Medium,
        bodyLargeSemiBold: bodyLargeSemiBold ?? this.bodyLargeSemiBold,
        bodyLargeMedium: bodyLargeMedium ?? this.bodyLargeMedium,
        bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
        bodySmallSemiBold: bodySmallSemiBold ?? this.bodySmallSemiBold,
        bodySmallMedium: bodySmallMedium ?? this.bodySmallMedium,
        bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
        captionLargeSemiBold: captionLargeSemiBold ?? this.captionLargeSemiBold,
        captionLargeMedium: captionLargeMedium ?? this.captionLargeMedium,
        captionLargeRegular: captionLargeRegular ?? this.captionLargeRegular,
        captionMediumSemiBold: captionMediumSemiBold ?? this.captionMediumSemiBold,
        captionMediumMedium: captionMediumMedium ?? this.captionMediumMedium,
        captionMediumRegular: captionMediumRegular ?? this.captionMediumRegular,
        captionSmallSemiBold: captionSmallSemiBold ?? this.captionSmallSemiBold,
        captionSmallMedium: captionSmallMedium ?? this.captionSmallMedium,
        captionSmallRegular: captionSmallRegular ?? this.captionSmallRegular,
        buttonL: buttonL ?? this.buttonL,
        buttonM: buttonM ?? this.buttonM,
      );

  @override
  ThemeExtension<ThemeTextStylesV3> lerp(
    ThemeExtension<ThemeTextStylesV3>? other,
    double t,
  ) {
    if (other is! ThemeTextStylesV3) {
      return this;
    }

    return ThemeTextStylesV3(
      h1SemiBold: TextStyle.lerp(h1SemiBold, other.h1SemiBold, t)!,
      h1Medium: TextStyle.lerp(h1Medium, other.h1Medium, t)!,
      h2SemiBold: TextStyle.lerp(h2SemiBold, other.h2SemiBold, t)!,
      h2Medium: TextStyle.lerp(h2Medium, other.h2Medium, t)!,
      h3SemiBold: TextStyle.lerp(h3SemiBold, other.h3SemiBold, t)!,
      h3Medium: TextStyle.lerp(h3Medium, other.h3Medium, t)!,
      h4SemiBold: TextStyle.lerp(h4SemiBold, other.h4SemiBold, t)!,
      h4Medium: TextStyle.lerp(h4Medium, other.h4Medium, t)!,
      bodyLargeSemiBold: TextStyle.lerp(bodyLargeSemiBold, other.bodyLargeSemiBold, t)!,
      bodyLargeMedium: TextStyle.lerp(bodyLargeMedium, other.bodyLargeMedium, t)!,
      bodyLargeRegular: TextStyle.lerp(bodyLargeRegular, other.bodyLargeRegular, t)!,
      bodySmallSemiBold: TextStyle.lerp(bodySmallSemiBold, other.bodySmallSemiBold, t)!,
      bodySmallMedium: TextStyle.lerp(bodySmallMedium, other.bodySmallMedium, t)!,
      bodySmallRegular: TextStyle.lerp(bodySmallRegular, other.bodySmallRegular, t)!,
      captionLargeSemiBold: TextStyle.lerp(captionLargeSemiBold, other.captionLargeSemiBold, t)!,
      captionLargeMedium: TextStyle.lerp(captionLargeMedium, other.captionLargeMedium, t)!,
      captionLargeRegular: TextStyle.lerp(captionLargeRegular, other.captionLargeRegular, t)!,
      captionMediumSemiBold: TextStyle.lerp(captionMediumSemiBold, other.captionMediumSemiBold, t)!,
      captionMediumMedium: TextStyle.lerp(captionMediumMedium, other.captionMediumMedium, t)!,
      captionMediumRegular: TextStyle.lerp(captionMediumRegular, other.captionMediumRegular, t)!,
      captionSmallSemiBold: TextStyle.lerp(captionSmallSemiBold, other.captionSmallSemiBold, t)!,
      captionSmallMedium: TextStyle.lerp(captionSmallMedium, other.captionSmallMedium, t)!,
      captionSmallRegular: TextStyle.lerp(captionSmallRegular, other.captionSmallRegular, t)!,
      buttonL: TextStyle.lerp(buttonL, other.buttonL, t)!,
      buttonM: TextStyle.lerp(buttonM, other.buttonM, t)!,
    );
  }

  /// According to https://api.flutter.dev/flutter/painting/TextStyle-class.html
  /// We need to add the package name to the font style

  /// According to https://api.flutter.dev/flutter/painting/TextStyle-class.html
  /// We need to add the package name to the font style

  factory ThemeTextStylesV3.frutiger() {
    const _fontFamily = 'Frutiger';
    return ThemeTextStylesV3(
      ///Size:28 Weight:600 LH: 32
      h1SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 30,
        fontWeight: _semiBold,
        height: 36 / 30,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:28 Weight:500 LH: 32
      h1Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 30,
        fontWeight: _medium,
        height: 36 / 30,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:24 Weight:600 LH: 30
      h2SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: _semiBold,
        height: 30 / 24,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:24 Weight:500 LH: 30
      h2Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: _medium,
        height: 30 / 24,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:20 Weight:600 LH: 24
      h3SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: _semiBold,
        height: 24 / 20,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:20 Weight:500 LH: 24
      h3Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: _medium,
        height: 24 / 20,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:18 Weight:600 LH: 24
      h4SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: _semiBold,
        height: 24 / 18,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:18 Weight:500 LH: 24
      h4Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: _medium,
        height: 24 / 18,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 20
      bodyLargeSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _semiBold,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:500 LH: 20
      bodyLargeMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _medium,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:400 LH: 20
      bodyLargeRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _regular,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 18
      bodySmallSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:500 LH: 18
      bodySmallMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _medium,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 18
      bodySmallRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _regular,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:600 LH: 16
      captionLargeSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _semiBold,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:500 LH: 16
      captionLargeMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _medium,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:400 LH: 16
      captionLargeRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _regular,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:600 LH: 16
      captionMediumSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _semiBold,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:500 LH: 16
      captionMediumMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _medium,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:400 LH: 16
      captionMediumRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _regular,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 14
      captionSmallSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 14 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:11 Weight:500 LH: 14
      captionSmallMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 11,
        fontWeight: _medium,
        height: 14 / 11,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 14
      captionSmallRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _regular,
        height: 14 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 24
      buttonL: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _semiBold,
        height: 24 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 20
      buttonM: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 20 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),
    );
  }

  factory ThemeTextStylesV3.golos() {
    const _fontFamily = 'Golos';

    return ThemeTextStylesV3(
      ///Size:28 Weight:600 LH: 32
      h1SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 30,
        fontWeight: _semiBold,
        height: 36 / 30,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:28 Weight:500 LH: 32
      h1Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 30,
        fontWeight: _medium,
        height: 36 / 30,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:24 Weight:600 LH: 30
      h2SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: _semiBold,
        height: 30 / 24,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:24 Weight:500 LH: 30
      h2Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: _medium,
        height: 30 / 24,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:20 Weight:600 LH: 24
      h3SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: _semiBold,
        height: 24 / 20,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:20 Weight:500 LH: 24
      h3Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: _medium,
        height: 24 / 20,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:18 Weight:600 LH: 24
      h4SemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: _semiBold,
        height: 24 / 18,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:18 Weight:500 LH: 24
      h4Medium: const TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: _medium,
        height: 24 / 18,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 20
      bodyLargeSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _semiBold,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:500 LH: 20
      bodyLargeMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _medium,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:400 LH: 20
      bodyLargeRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _regular,
        height: 20 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 18
      bodySmallSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:500 LH: 18
      bodySmallMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _medium,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 18
      bodySmallRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _regular,
        height: 18 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:600 LH: 16
      captionLargeSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _semiBold,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:500 LH: 16
      captionLargeMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _medium,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:13 Weight:400 LH: 16
      captionLargeRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: _regular,
        height: 16 / 13,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:600 LH: 16
      captionMediumSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _semiBold,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:500 LH: 16
      captionMediumMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _medium,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:400 LH: 16
      captionMediumRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: _regular,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 14
      captionSmallSemiBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 14 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:11 Weight:500 LH: 14
      captionSmallMedium: const TextStyle(
        letterSpacing: 0,
        fontSize: 11,
        fontWeight: _medium,
        height: 14 / 11,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 14
      captionSmallRegular: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _regular,
        height: 14 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 24
      buttonL: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: _semiBold,
        height: 24 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 20
      buttonM: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: _semiBold,
        height: 20 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),
    );
  }
}
