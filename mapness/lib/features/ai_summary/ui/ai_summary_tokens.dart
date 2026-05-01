import 'package:flutter/material.dart';

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
  static const double cardBorderRadius = 12;
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardOuterMargin = EdgeInsets.only(left: 16, right: 16, bottom: 12);

  // --- Header: sparkle icon + "AI SUMMARY" label + "BALADY AI" badge ---
  static const double headerSpacing = 8;
  static const double sparkleSize = 18;

  // Muted violet pill with white text and a subtle left-to-right
  // gradient for the "BALADY AI" badge. Keep the badge on-brand
  // across modes — white text on violet works on either backdrop.
  static const LinearGradient badgeGradient = LinearGradient(
    colors: [Color(0xFFA293F0), Color(0xFF7968D9)],
  );
  static const Color badgeTextColor = Colors.white;
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
  static const double badgeBorderRadius = 4;
  static const TextStyle badgeTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: Colors.white,
  );

  // --- Description body text ---
  static const EdgeInsets descriptionPadding = EdgeInsets.only(top: 12);

  // --- Rating bar ---
  static const EdgeInsets ratingPadding = EdgeInsets.only(top: 12);
  static const double ratingStarSize = 16;
  static const double ratingStarSpacing = 2;
  static const double ratingStarToValueSpacing = 6;
  static const double ratingValueToCountSpacing = 6;

  // --- Transit lines section (bus / metro station POIs only) ---
  static const EdgeInsets transitSectionPadding = EdgeInsets.only(top: 14);
  static const double transitBadgeGap = 8;
  static const EdgeInsets transitBadgePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const double transitBadgeBorderRadius = 8;
  // Per-line badge text always white — line backgrounds come from feed.
  static const TextStyle transitBadgeTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // --- Footer: "Powered by Balady AI · Based on verified sources" ---
  static const EdgeInsets footerPadding = EdgeInsets.only(top: 14);

  // --- Skeleton shimmer geometry ---
  static const double skeletonLineHeight = 12;
  static const double skeletonLineGap = 8;
  static const double skeletonLineRadius = 4;

  static AiSummaryPalette paletteFor({required bool isDark}) =>
      isDark ? AiSummaryPalette.dark : AiSummaryPalette.light;
}

/// Theme-dependent colour set for the AI Summary card.
///
/// Two const instances are exposed (`light`, `dark`). Pick via
/// [AiSummaryTokens.paletteFor]. Values remain placeholders
/// awaiting the final Figma; the dark variant was chosen by eye
/// to read well against the Mekkah dark backdrop (`#131A19`).
@immutable
class AiSummaryPalette {
  final Color cardBackground;
  final Color cardBorder;
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

  static const AiSummaryPalette light = AiSummaryPalette(
    cardBackground: Color(0xFFF3F2FB),
    cardBorder: Color(0xFFE6E3F5),
    sparkleColor: Color(0xFFF5B638),
    labelTextStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      color: Color(0xFF3D5A9C),
    ),
    descriptionTextStyle: TextStyle(
      fontSize: 14,
      height: 1.45,
      color: Color(0xFF111827),
    ),
    ratingStarFilled: Color(0xFFF59E0B),
    ratingStarEmpty: Color(0xFFD1D5DB),
    ratingValueStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF111827),
    ),
    ratingCountStyle: TextStyle(
      fontSize: 13,
      color: Color(0xFF6B7280),
    ),
    transitSectionLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF6B7280),
    ),
    footerTextStyle: TextStyle(
      fontSize: 11,
      color: Color(0xFF9CA3AF),
    ),
    shimmerBase: Color(0xFFE3E3E3),
    shimmerHighlight: Color(0xFFF5F5F5),
  );

  static const AiSummaryPalette dark = AiSummaryPalette(
    // Slightly lifted off the dashboard backdrop so the card reads
    // as a distinct surface, matching the visual weight of the
    // light pale-lavender tile against cream.
    cardBackground: Color(0xFF1E2625),
    cardBorder: Color(0xFF2C3938),
    // Sparkle keeps its golden hue — high-contrast on dark.
    sparkleColor: Color(0xFFF5B638),
    labelTextStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      // Lighter indigo so the AI SUMMARY label still reads as the
      // brand-coloured chip rather than blending with body text.
      color: Color(0xFFA9B7E0),
    ),
    descriptionTextStyle: TextStyle(
      fontSize: 14,
      height: 1.45,
      color: Color(0xFFE5E7EB),
    ),
    ratingStarFilled: Color(0xFFFBBF24),
    ratingStarEmpty: Color(0xFF4B5563),
    ratingValueStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFFE5E7EB),
    ),
    ratingCountStyle: TextStyle(
      fontSize: 13,
      color: Color(0xFF9CA3AF),
    ),
    transitSectionLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF9CA3AF),
    ),
    footerTextStyle: TextStyle(
      fontSize: 11,
      color: Color(0xFF6B7280),
    ),
    shimmerBase: Color(0xFF2C3938),
    shimmerHighlight: Color(0xFF3D4D4B),
  );
}
