import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/material.dart';

const regular = FontWeight.w400;
const semiBold = FontWeight.w600;
const bold = FontWeight.w700;

class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  ///Size:28 Weight:600 LH: 32
  final TextStyle accent;

  ///Size:22 Weight:600 LH: 32
  final TextStyle heading1;

  ///Size:18 Weight:600 LH: 28
  final TextStyle heading2;

  ///Size:16 Weight:600 LH: 24
  final TextStyle callout;

  ///Size:16 Weight:400 LH: 24
  final TextStyle text;

  ///Size:14 Weight:400 LH: 20
  final TextStyle footNote;

  ///Size:14 Weight:600 LH: 20
  final TextStyle footNoteBold;

  ///Size:12 Weight:400 LH: 16
  final TextStyle caption;

  ThemeTextStyles({
    required this.accent,
    required this.heading1,
    required this.heading2,
    required this.text,
    required this.caption,
    required this.callout,
    required this.footNote,
    required this.footNoteBold,
  });

  @override
  ThemeExtension<ThemeTextStyles> copyWith({
    TextStyle? accent,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? text,
    TextStyle? caption,
    TextStyle? callout,
    TextStyle? footNote,
    TextStyle? footNoteBold,
  }) =>
      ThemeTextStyles(
        accent: accent ?? this.accent,
        heading1: heading1 ?? this.heading1,
        heading2: heading2 ?? this.heading2,
        text: text ?? this.text,
        caption: caption ?? this.caption,
        callout: callout ?? this.callout,
        footNote: footNote ?? this.footNote,
        footNoteBold: footNoteBold ?? this.footNoteBold,
      );

  @override
  ThemeExtension<ThemeTextStyles> lerp(
    ThemeExtension<ThemeTextStyles>? other,
    double t,
  ) {
    if (other is! ThemeTextStyles) {
      return this;
    }

    return ThemeTextStyles(
      accent: TextStyle.lerp(accent, other.accent, t)!,
      heading1: TextStyle.lerp(heading1, other.heading1, t)!,
      heading2: TextStyle.lerp(heading2, other.heading2, t)!,
      text: TextStyle.lerp(text, other.text, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      callout: TextStyle.lerp(callout, other.callout, t)!,
      footNote: TextStyle.lerp(footNote, other.footNote, t)!,
      footNoteBold: TextStyle.lerp(footNoteBold, other.footNoteBold, t)!,
    );
  }

  /// According to https://api.flutter.dev/flutter/painting/TextStyle-class.html
  /// We need to add the package name to the font style

  factory ThemeTextStyles.arabic() {
    const _fontFamily = 'Frutiger';
    return ThemeTextStyles(
      ///Size:28 Weight:600 LH: 32
      accent: const TextStyle(
        letterSpacing: 0,
        fontSize: 28,
        fontWeight: bold,
        height: 32 / 28,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:22 Weight:600 LH: 32
      heading1: const TextStyle(
        letterSpacing: 0,
        fontSize: 22,
        fontWeight: bold,
        height: 32 / 22,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:18 Weight:600 LH: 28
      heading2: const TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: semiBold,
        height: 28 / 18,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 24
      callout: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: bold,
        height: 24 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:16 Weight:400 LH: 24
      text: const TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: regular,
        height: 24 / 16,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 20
      footNote: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: regular,
        height: 20 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 20
      footNoteBold: const TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: bold,
        height: 20 / 14,
        fontFamily: _fontFamily,
        package: packageName,
      ),

      ///Size:12 Weight:400 LH: 16
      caption: const TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: regular,
        height: 16 / 12,
        fontFamily: _fontFamily,
        package: packageName,
      ),
    );
  }

  factory ThemeTextStyles.english() {
    const _fontFamily = 'Inter';
    return ThemeTextStyles(
      ///Size:28 Weight:600 LH: 32
      accent: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 28,
        fontWeight: semiBold,
        height: 32 / 28,
        package: packageName,
      ),

      ///Size:22 Weight:600 LH: 32
      heading1: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 22,
        fontWeight: semiBold,
        height: 32 / 22,
        package: packageName,
      ),

      ///Size:18 Weight:600 LH: 28
      heading2: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: semiBold,
        height: 28 / 18,
        package: packageName,
      ),

      ///Size:16 Weight:600 LH: 24
      callout: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: semiBold,
        height: 24 / 16,
        package: packageName,
      ),

      ///Size:16 Weight:400 LH: 24
      text: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: regular,
        height: 24 / 16,
        package: packageName,
      ),

      ///Size:14 Weight:400 LH: 20
      footNote: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: regular,
        height: 20 / 14,
        package: packageName,
      ),

      ///Size:14 Weight:600 LH: 20
      footNoteBold: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: semiBold,
        height: 20 / 14,
        package: packageName,
      ),

      ///Size:12 Weight:400 LH: 16
      caption: const TextStyle(
        fontFamily: _fontFamily,
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: regular,
        height: 16 / 12,
        package: packageName,
      ),
    );
  }
}
