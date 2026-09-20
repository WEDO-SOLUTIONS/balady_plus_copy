import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_tokens.dart';
import 'package:mapness/features/ai_summary/ui/widgets/ai_summary_rating_bar.dart';
import 'package:mapness/features/ai_summary/ui/widgets/ai_summary_transit_badges.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:shimmer/shimmer.dart';

/// The AI Summary card as it appears inside the POI bottom
/// sheet when the sheet is fully expanded. Presentation-only:
/// takes a [AiSummary] fixture and renders it.
///
/// Resolves an [AiSummaryPalette] from [darkModeProvider] and
/// passes it down so colors flip with the global app theme.
class AiSummaryCard extends ConsumerWidget {
  final AiSummary? summary;
  final Language language;
  final bool _isSkeleton;

  const AiSummaryCard({
    required AiSummary this.summary,
    required this.language,
    super.key,
  }) : _isSkeleton = false;

  /// Loading state: shimmer placeholders for header, description
  /// lines, and rating bar. Used while the AI Summary request is
  /// in flight.
  const AiSummaryCard.skeleton({
    required this.language,
    super.key,
  }) : summary = null,
       _isSkeleton = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final palette = AiSummaryTokens.paletteFor(isDark: isDark);
    return Container(
      margin: AiSummaryTokens.cardOuterMargin,
      padding: AiSummaryTokens.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        // border: palette.cardBorder == Colors.transparent ? null : Border.all(color: palette.cardBorder),
        borderRadius: BorderRadius.circular(AiSummaryTokens.cardBorderRadius),
        // boxShadow: palette.cardShadow,
      ),
      child: _isSkeleton
          ? _SkeletonBody(palette: palette)
          : _DataBody(summary: summary!, language: language, palette: palette),
    );
  }
}

class _DataBody extends StatelessWidget {
  final AiSummary summary;
  final Language language;
  final AiSummaryPalette palette;

  const _DataBody({required this.summary, required this.language, required this.palette});

  @override
  Widget build(BuildContext context) {
    final hasRating = summary.rating != null && summary.reviewCount != null;
    final hasTransit = summary.transitLines != null && summary.transitLines!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(palette: palette),
        Padding(
          padding: AiSummaryTokens.descriptionPadding,
          child: Text(summary.description, style: palette.descriptionTextStyle),
        ),
        if (hasRating)
          Padding(
            padding: AiSummaryTokens.ratingPadding,
            child: AiSummaryRatingBar(
              rating: summary.rating!,
              reviewCount: summary.reviewCount!,
              palette: palette,
            ),
          ),
        if (hasTransit)
          Padding(
            padding: AiSummaryTokens.transitSectionPadding,
            child: AiSummaryTransitBadges(
              lines: summary.transitLines!,
              language: language,
              palette: palette,
            ),
          ),
        Padding(
          padding: AiSummaryTokens.footerPadding,
          child: Text(context.l10n.aiSummaryPoweredBy, style: palette.footerTextStyle),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final AiSummaryPalette palette;

  const _Header({required this.palette});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Flexible(
        child: AutoSizeText(
          context.l10n.aiSummaryLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // Same locale-aware token the address ContentRow title resolves to:
          // the uikit picks the font family per language (Golos / IBMPlexSansArabic),
          // which a const palette TextStyle cannot do — see BALADY-3626.
          style: context.textStyles.bodyLargeSemiBold.copyWith(color: palette.labelTextStyle.color),
        ),
      ),
      const SizedBox(width: AiSummaryTokens.headerSpacing),
      Flexible(
        child: Container(
          padding: AiSummaryTokens.badgePadding,
          decoration: BoxDecoration(
            gradient: palette.badgeGradient,
            borderRadius: BorderRadius.circular(AiSummaryTokens.badgeBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: AiSummaryTokens.sparkleSize,
                color: palette.sparkleColor,
              ),
              const SizedBox(width: AiSummaryTokens.badgeIconToTextSpacing),
              Flexible(
                child: AutoSizeText(
                  context.l10n.aiSummaryBaladyBadge,
                  maxLines: 1,
                  minFontSize: 9,
                  overflow: TextOverflow.ellipsis,
                  style: palette.badgeTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SkeletonBody extends StatelessWidget {
  final AiSummaryPalette palette;

  const _SkeletonBody({required this.palette});

  @override
  // Header is rendered statically outside the shimmer wrapper —
  // only the description placeholders animate while loading.
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Header(palette: palette),
      Shimmer.fromColors(
        baseColor: palette.shimmerBase,
        highlightColor: palette.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AiSummaryTokens.skeletonLineGap * 1.5),
            _SkeletonLine(widthFactor: 1.0, color: palette.shimmerBase),
            const SizedBox(height: AiSummaryTokens.skeletonLineGap),
            _SkeletonLine(widthFactor: 0.96, color: palette.shimmerBase),
            const SizedBox(height: AiSummaryTokens.skeletonLineGap),
            _SkeletonLine(widthFactor: 0.88, color: palette.shimmerBase),
            const SizedBox(height: AiSummaryTokens.skeletonLineGap),
            _SkeletonLine(widthFactor: 0.6, color: palette.shimmerBase),
            const SizedBox(height: AiSummaryTokens.skeletonLineGap * 2),
            _SkeletonLine(widthFactor: 0.45, height: 14, color: palette.shimmerBase),
          ],
        ),
      ),
    ],
  );
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  final Color color;

  const _SkeletonLine({
    required this.widthFactor,
    required this.color,
    this.height = AiSummaryTokens.skeletonLineHeight,
  });

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    widthFactor: widthFactor,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AiSummaryTokens.skeletonLineRadius),
      ),
    ),
  );
}
