import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/ui/_preview_fixtures.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_strings.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_tokens.dart';
import 'package:mapness/features/ai_summary/ui/widgets/ai_summary_rating_bar.dart';
import 'package:mapness/features/ai_summary/ui/widgets/ai_summary_transit_badges.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:shimmer/shimmer.dart';

/// The AI Summary card as it appears inside the POI bottom
/// sheet when the sheet is fully expanded. Presentation-only:
/// takes a [PreviewAiSummary] fixture and renders it.
///
/// Data wiring (Riverpod provider, cache, mock repository)
/// lives in Phase 2+ and hooks in via a separate `AiSummarySection`
/// wrapper — this widget stays as a pure presentation component
/// so it can be previewed and visually iterated on in isolation.
class AiSummaryCard extends StatelessWidget {
  final PreviewAiSummary? summary;
  final Language language;
  final bool _isSkeleton;

  const AiSummaryCard({
    required PreviewAiSummary this.summary,
    required this.language,
    super.key,
  }) : _isSkeleton = false;

  /// Loading state: shimmer placeholders for header, description
  /// lines, and rating bar. Used while the AI Summary request is
  /// in flight.
  const AiSummaryCard.skeleton({
    required this.language,
    super.key,
  })  : summary = null,
        _isSkeleton = true;

  @override
  Widget build(BuildContext context) => Container(
        margin: AiSummaryTokens.cardOuterMargin,
        padding: AiSummaryTokens.cardPadding,
        decoration: BoxDecoration(
          color: AiSummaryTokens.cardBackground,
          border: Border.all(color: AiSummaryTokens.cardBorder),
          borderRadius: BorderRadius.circular(AiSummaryTokens.cardBorderRadius),
        ),
        child: _isSkeleton
            ? _SkeletonBody(language: language)
            : _DataBody(summary: summary!, language: language),
      );
}

class _DataBody extends StatelessWidget {
  final PreviewAiSummary summary;
  final Language language;

  const _DataBody({required this.summary, required this.language});

  @override
  Widget build(BuildContext context) {
    final strings = AiSummaryStrings(language);
    final hasRating = summary.rating != null && summary.reviewCount != null;
    final hasTransit = summary.transitLines != null && summary.transitLines!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(strings: strings),
        Padding(
          padding: AiSummaryTokens.descriptionPadding,
          child: Text(summary.description, style: AiSummaryTokens.descriptionTextStyle),
        ),
        if (hasRating)
          Padding(
            padding: AiSummaryTokens.ratingPadding,
            child: AiSummaryRatingBar(
              rating: summary.rating!,
              reviewCount: summary.reviewCount!,
              language: language,
            ),
          ),
        if (hasTransit)
          Padding(
            padding: AiSummaryTokens.transitSectionPadding,
            child: AiSummaryTransitBadges(
              lines: summary.transitLines!,
              language: language,
            ),
          ),
        Padding(
          padding: AiSummaryTokens.footerPadding,
          child: Text(strings.poweredBy, style: AiSummaryTokens.footerTextStyle),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final AiSummaryStrings strings;

  const _Header({required this.strings});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            size: AiSummaryTokens.sparkleSize,
            color: AiSummaryTokens.sparkleColor,
          ),
          const SizedBox(width: AiSummaryTokens.headerSpacing),
          Text(strings.label, style: AiSummaryTokens.labelTextStyle),
          const SizedBox(width: AiSummaryTokens.headerSpacing),
          Container(
            padding: AiSummaryTokens.badgePadding,
            decoration: BoxDecoration(
              color: AiSummaryTokens.badgeBackground,
              borderRadius: BorderRadius.circular(AiSummaryTokens.badgeBorderRadius),
            ),
            child: Text(strings.baladyBadge, style: AiSummaryTokens.badgeTextStyle),
          ),
        ],
      );
}

class _SkeletonBody extends StatelessWidget {
  final Language language;

  const _SkeletonBody({required this.language});

  @override
  Widget build(BuildContext context) {
    // Header stays visible (it's static, no reason to hide it)
    // while only the generated content area is skeletoned.
    final strings = AiSummaryStrings(language);

    return Shimmer.fromColors(
      baseColor: AiSummaryTokens.shimmerBase,
      highlightColor: AiSummaryTokens.shimmerHighlight,
      // Shimmer is painted over the placeholder blocks only;
      // the header is wrapped in an opacity shortcut so it also
      // feels part of the loading state without us re-building it.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(strings: strings),
          const SizedBox(height: AiSummaryTokens.skeletonLineGap * 1.5),
          const _SkeletonLine(widthFactor: 1.0),
          const SizedBox(height: AiSummaryTokens.skeletonLineGap),
          const _SkeletonLine(widthFactor: 0.96),
          const SizedBox(height: AiSummaryTokens.skeletonLineGap),
          const _SkeletonLine(widthFactor: 0.88),
          const SizedBox(height: AiSummaryTokens.skeletonLineGap),
          const _SkeletonLine(widthFactor: 0.6),
          const SizedBox(height: AiSummaryTokens.skeletonLineGap * 2),
          const _SkeletonLine(widthFactor: 0.45, height: 14),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;

  const _SkeletonLine({
    required this.widthFactor,
    this.height = AiSummaryTokens.skeletonLineHeight,
  });

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: AiSummaryTokens.shimmerBase,
            borderRadius: BorderRadius.circular(AiSummaryTokens.skeletonLineRadius),
          ),
        ),
      );
}
