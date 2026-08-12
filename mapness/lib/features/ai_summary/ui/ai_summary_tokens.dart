import 'package:flutter/material.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';

/// Visual design tokens for the AI Summary POI card section.
///
/// Layout/sizing tokens are theme-invariant `static const`. Colour
/// tokens live on [AiSummaryPalette] with `light` and `dark`
/// const instances; [AiSummaryTokens.paletteFor] picks one based
/// on the resolved app theme. Once the designer delivers a final
/// Figma the palette values can be swapped in one place.
class AiSummaryTokens {
  const AiSummaryTokens._();

  // --- Card container ---
  static const double cardBorderWidth = 1;
  static const double cardBorderRadius = 16;
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardOuterMargin = EdgeInsets.only(left: 16, right: 16, bottom: 12);

  // --- Header: "AI Summary" label + "Balady AI" badge (sparkle inside badge) ---
  static const double headerSpacing = 12;
  // Sparkle now lives inside the badge.
  static const double sparkleSize = 12;
  static const double badgeIconToTextSpacing = 4;

  // Teal gradient pill matching the Makkah-Dark accent ribbon
  // (Figma node 1777:23872). Used by [AiSummaryPalette.dark.badgeGradient].
  static const LinearGradient badgeGradientDark = LinearGradient(
    stops: [0.017, 0.192, 0.473, 0.786, 0.974],
    colors: [
      Color(0xFF083F46),
      Color(0xFF068B81),
      Color(0xFF31CDC2),
      Color(0xFF068B81),
      Color(0xFF083F46),
    ],
  );
  // Gold/amber gradient pill matching the Makkah-Light accent
  // (Figma node 1777:23839). Used by [AiSummaryPalette.light.badgeGradient].
  static const LinearGradient badgeGradientLight = LinearGradient(
    stops: [0.017, 0.192, 0.473, 0.786, 0.974],
    colors: [
      Color(0xFFD19D3F),
      Color(0xFFFFCA69),
      Color(0xFFFFECC9),
      Color(0xFFFFCA69),
      Color(0xFFD19D3F),
    ],
  );

  static const EdgeInsets badgePadding = EdgeInsets.fromLTRB(4, 3, 6, 3);
  static const double badgeBorderRadius = 6;

  // --- Description body text ---
  // Figma uses a single column gap of 10px between every section (1777:23869 / 1777:23836).
  static const EdgeInsets descriptionPadding = EdgeInsets.only(top: 10);

  // --- Rating bar ---
  static const EdgeInsets ratingPadding = EdgeInsets.only(top: 10);
  static const double ratingStarSize = 16;
  static const double ratingStarSpacing = 4;
  static const double ratingStarToValueSpacing = 6;
  static const double ratingValueToCountSpacing = 6;

  // --- Transit lines section (bus / metro station POIs only) ---
  static const EdgeInsets transitSectionPadding = EdgeInsets.only(top: 14);
  static const double transitBadgeGap = 8;
  static const EdgeInsets transitBadgePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const double transitBadgeBorderRadius = 8;
  // Per-line badge text always white — line backgrounds come from feed.
  static const TextStyle transitBadgeTextStyle = TextStyle(
    fontFamily: _aiSummaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // --- Footer: "Powered by Balady AI · Based on verified sources" ---
  static const EdgeInsets footerPadding = EdgeInsets.only(top: 10);

  // --- Skeleton shimmer geometry ---
  static const double skeletonLineHeight = 12;
  static const double skeletonLineGap = 8;
  static const double skeletonLineRadius = 4;

  static AiSummaryPalette paletteFor({required bool isDark}) => isDark ? AiSummaryPalette.dark : AiSummaryPalette.light;
}

const _aiSummaryFont = 'Golos Text';

/// Theme-dependent colour set for the AI Summary card.
///
/// Two const instances are exposed (`light`, `dark`). Pick via
/// [AiSummaryTokens.paletteFor]. The dark variant is tuned to
/// match the surrounding `_MakkahContentCard` surface treatment
/// in the Makkah-Dark POI sheet so the AI summary card reads as
/// a peer of the neighbouring "Address", fact-tile and warning
/// containers (same `darkSunken` fill, `RadiusBorder.xl`, and
/// 4-12 drop shadow).
@immutable
class AiSummaryPalette {
  final Color cardBackground;
  final Color cardBorder;
  final List<BoxShadow> cardShadow;
  final LinearGradient badgeGradient;
  final TextStyle badgeTextStyle;
  final Color sparkleColor;
  final TextStyle labelTextStyle;
  final TextStyle descriptionTextStyle;
  final Color ratingStarFilled;
  final Color ratingStarEmpty;
  final TextStyle ratingValueStyle;
  final TextStyle ratingCountStyle;
  final TextStyle transitSectionLabelStyle;
  final TextStyle footerTextStyle;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const AiSummaryPalette({
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.badgeGradient,
    required this.badgeTextStyle,
    required this.sparkleColor,
    required this.labelTextStyle,
    required this.descriptionTextStyle,
    required this.ratingStarFilled,
    required this.ratingStarEmpty,
    required this.ratingValueStyle,
    required this.ratingCountStyle,
    required this.transitSectionLabelStyle,
    required this.footerTextStyle,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  static final AiSummaryPalette light = AiSummaryPalette(
    cardBackground: MakkahPoiConstants.headerBackground,
    cardBorder: Colors.transparent,
    cardShadow: const [],
    badgeGradient: AiSummaryTokens.badgeGradientLight,
    badgeTextStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 14 / 11,
      color: Color(0xFF9D6808),
    ),
    // Dark amber on the gold gradient — matches Figma 1777:23840 icon tint.
    sparkleColor: const Color(0xFF9D6808),
    // Font and color intentionally match the address-section title above this
    // card (ContentRow's bodyLargeSemiBold + context.colors.foregroundDefault)
    // instead of the Makkah brand tokens used elsewhere in this palette —
    // see BALADY-3626. `_aiSummaryFont` ('Golos Text') isn't a registered font
    // family in this app, so it silently fell back to the system font; the
    // uikit bundles the same typeface as 'Golos' and requires the package arg.
    labelTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      color: Color(0xFF1B1B1B),
      fontFamily: 'Golos',
      package: 'balady_uikit',
    ),
    descriptionTextStyle: TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 14,
      height: 18 / 14,
      color: MakkahPoiConstants.primaryTextColor.withOpacity(0.8),
    ),
    ratingStarFilled: const Color(0xFFF59E0B),
    ratingStarEmpty: const Color(0xFFD1D5DB),
    ratingValueStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      color: MakkahPoiConstants.primaryTextColor,
    ),
    ratingCountStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 13,
      height: 16 / 13,
      color: MakkahPoiConstants.closeButtonIcon,
    ),
    transitSectionLabelStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: MakkahPoiConstants.closeButtonIcon,
    ),
    footerTextStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 14 / 11,
      color: MakkahPoiConstants.closeButtonIcon,
    ),
    shimmerBase: const Color(0xFFE3E3E3),
    shimmerHighlight: const Color(0xFFF5F5F5),
  );

  static final AiSummaryPalette dark = AiSummaryPalette(
    // Same surface as the surrounding "About", fact-tile and warning containers
    // in the Makkah-Dark POI sheet.
    cardBackground: MakkahPoiConstants.darkSunken,
    // No visible outline in the Makkah-Dark spec — keep the field
    // present so the palette shape is symmetrical with the light variant.
    cardBorder: Colors.transparent,
    // Mirrors `_MakkahContentCard` (poi_card_content_info.dart:330) so the
    // AI summary card sits at the same elevation as its peers in the sheet.
    cardShadow: const [
      BoxShadow(
        blurRadius: 12,
        offset: Offset(0, 4),
        color: Color(0x0FFFFFFF),
      ),
    ],
    badgeGradient: AiSummaryTokens.badgeGradientDark,
    // Figma applies opacity 0.8 to the badge contents (sparkle + "Balady AI")
    // via the `subtitleExtra1` wrapper — node 1777:23874.
    badgeTextStyle: TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 14 / 11,
      color: MakkahPoiConstants.darkPrimaryTextColor.withOpacity(0.8),
    ),
    sparkleColor: MakkahPoiConstants.darkPrimaryTextColor.withOpacity(0.8),
    // Font fixed to the registered uikit font, same as the light variant
    // above — color is unchanged (already correct per BALADY-3626).
    labelTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      color: MakkahPoiConstants.darkPrimaryTextColor,
      fontFamily: 'Golos',
      package: 'balady_uikit',
    ),
    descriptionTextStyle: TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 14,
      height: 18 / 14,
      color: MakkahPoiConstants.darkSecondaryTextColor, // white @ 80%
    ),
    ratingStarFilled: const Color(0xFFFBBF24),
    ratingStarEmpty: const Color(0xFF4B5563),
    ratingValueStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      color: MakkahPoiConstants.darkPrimaryTextColor,
    ),
    ratingCountStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 13,
      height: 16 / 13,
      color: MakkahPoiConstants.darkPrimaryTextColor,
    ),
    transitSectionLabelStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF9CA3AF),
    ),
    footerTextStyle: const TextStyle(
      fontFamily: _aiSummaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 14 / 11,
      color: Color(0x99FFFFFF), // white @ 60%
    ),
    shimmerBase: const Color(0xFF2C3938),
    shimmerHighlight: const Color(0xFF3D4D4B),
  );
}
