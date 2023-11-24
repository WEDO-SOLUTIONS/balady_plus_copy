import 'package:balady_uikit/typography/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  final TextStyle headingXL;
  final TextStyle headingL;
  final TextStyle headingM;
  final TextStyle headingS;
  final TextStyle textL;
  final TextStyle textM;
  final TextStyle textS;
  final TextStyle textXS;
  final TextStyle accentL;
  final TextStyle accentM;
  final TextStyle accentS;
  final TextStyle accentXS;

  ThemeTextStyles({
    required this.headingXL,
    required this.headingL,
    required this.headingM,
    required this.headingS,
    required this.textL,
    required this.textM,
    required this.textS,
    required this.textXS,
    required this.accentL,
    required this.accentM,
    required this.accentS,
    required this.accentXS,
  });

  @override
  ThemeExtension<ThemeTextStyles> copyWith({
    TextStyle? headingXL,
    TextStyle? headingL,
    TextStyle? headingM,
    TextStyle? headingS,
    TextStyle? textL,
    TextStyle? textM,
    TextStyle? textS,
    TextStyle? textXS,
    TextStyle? accentL,
    TextStyle? accentM,
    TextStyle? accentS,
    TextStyle? accentXS,
  }) {
    return ThemeTextStyles(
      headingXL: headingXL ?? this.headingXL,
      headingL: headingL ?? this.headingL,
      headingM: headingM ?? this.headingM,
      headingS: headingS ?? this.headingS,
      textL: textL ?? this.textL,
      textM: textM ?? this.textM,
      textS: textS ?? this.textS,
      textXS: textXS ?? this.textXS,
      accentL: accentL ?? this.accentL,
      accentM: accentM ?? this.accentM,
      accentS: accentS ?? this.accentS,
      accentXS: accentXS ?? this.accentXS,
    );
  }

  @override
  ThemeExtension<ThemeTextStyles> lerp(
    ThemeExtension<ThemeTextStyles>? other,
    double t,
  ) {
    if (other is! ThemeTextStyles) {
      return this;
    }

    return ThemeTextStyles(
      headingXL: TextStyle.lerp(headingXL, other.headingXL, t)!,
      headingL: TextStyle.lerp(headingL, other.headingL, t)!,
      headingM: TextStyle.lerp(headingM, other.headingM, t)!,
      headingS: TextStyle.lerp(headingS, other.headingS, t)!,
      textL: TextStyle.lerp(textL, other.textL, t)!,
      textM: TextStyle.lerp(textM, other.textM, t)!,
      textS: TextStyle.lerp(textS, other.textS, t)!,
      textXS: TextStyle.lerp(textXS, other.textXS, t)!,
      accentL: TextStyle.lerp(accentL, other.accentL, t)!,
      accentM: TextStyle.lerp(accentM, other.accentM, t)!,
      accentS: TextStyle.lerp(accentS, other.accentS, t)!,
      accentXS: TextStyle.lerp(accentXS, other.accentXS, t)!,
    );
  }

  static ThemeTextStyles get arabic => ThemeTextStyles(
        headingXL: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: "Frutiger LT Arabic",
        ),
        headingL: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 27,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: "Frutiger LT Arabic",
        ),
        headingM: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: "Frutiger LT Arabic",
        ),
        headingS: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: "Frutiger LT Arabic",
        ),
        textL: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        textM: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        textS: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        textXS: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        accentL: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        accentM: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        accentS: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
        accentXS: const TextStyle(
          color: Palette.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
          fontFamily: "Frutiger LT Arabic",
        ),
      );

  static get english => ThemeTextStyles(
        headingXL: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headingL: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 27,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headingM: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headingS: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        textL: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        textM: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        textS: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        textXS: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        accentL: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        accentM: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        accentS: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        accentXS: GoogleFonts.inter(
          color: Palette.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      );
}
