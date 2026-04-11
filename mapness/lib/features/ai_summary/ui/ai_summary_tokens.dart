import 'package:flutter/material.dart';

/// Visual design tokens for the AI Summary POI card section.
///
/// All values here are placeholders chosen by eye from the
/// RME-AI Summary mockup PDF and should be replaced once the
/// designer delivers the final Figma. Keeping everything in
/// one file makes that future swap a single-commit operation.
class AiSummaryTokens {
  const AiSummaryTokens._();

  // --- Card container ---
  // placeholder, awaiting Figma
  static const Color cardBackground = Color(0xFFF5F7FB);
  // placeholder, awaiting Figma
  static const Color cardBorder = Color(0xFFE3E7F1);
  static const double cardBorderWidth = 1;
  static const double cardBorderRadius = 12;
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardOuterMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  // --- Header: sparkle icon + "AI SUMMARY" label + "BALADY AI" badge ---
  static const double headerSpacing = 8;
  // placeholder, awaiting Figma
  static const Color sparkleColor = Color(0xFF7B61FF);
  static const double sparkleSize = 18;

  // placeholder, awaiting Figma
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: Color(0xFF6B7280),
  );

  // placeholder, awaiting Figma
  static const Color badgeBackground = Color(0xFF1F2937);
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
  // placeholder, awaiting Figma
  static const TextStyle descriptionTextStyle = TextStyle(
    fontSize: 14,
    height: 1.45,
    color: Color(0xFF111827),
  );

  // --- Rating bar ---
  static const EdgeInsets ratingPadding = EdgeInsets.only(top: 12);
  static const double ratingStarSize = 16;
  static const double ratingStarSpacing = 2;
  static const double ratingStarToValueSpacing = 6;
  static const double ratingValueToCountSpacing = 6;
  // placeholder, awaiting Figma
  static const Color ratingStarFilled = Color(0xFFF59E0B);
  static const Color ratingStarEmpty = Color(0xFFD1D5DB);
  static const TextStyle ratingValueStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Color(0xFF111827),
  );
  static const TextStyle ratingCountStyle = TextStyle(
    fontSize: 13,
    color: Color(0xFF6B7280),
  );

  // --- Transit lines section (bus / metro station POIs only) ---
  static const EdgeInsets transitSectionPadding = EdgeInsets.only(top: 14);
  static const double transitBadgeGap = 8;
  static const TextStyle transitSectionLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
  );
  static const EdgeInsets transitBadgePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const double transitBadgeBorderRadius = 8;
  static const TextStyle transitBadgeTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // --- Footer: "Powered by Balady AI · Based on verified sources" ---
  static const EdgeInsets footerPadding = EdgeInsets.only(top: 14);
  static const TextStyle footerTextStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF9CA3AF),
  );

  // --- Skeleton shimmer ---
  // placeholder, awaiting Figma
  static const Color shimmerBase = Color(0xFFE3E3E3);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const double skeletonLineHeight = 12;
  static const double skeletonLineGap = 8;
  static const double skeletonLineRadius = 4;
}
