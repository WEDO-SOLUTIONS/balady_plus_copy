import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_tokens.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

/// Star rating + numeric value + review count.
///
/// Renders as: `★★★★☆  4.3  (127 reviews)`
///
/// The star row is locked to LTR direction so that the
/// progression of filled → empty stars reads consistently
/// regardless of app locale — in Arabic mode the parent
/// `Directionality` is RTL but the stars themselves stay LTR,
/// which matches how rating bars are conventionally displayed
/// across Arabic-localized apps.
class AiSummaryRatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final AiSummaryPalette palette;

  const AiSummaryRatingBar({
    required this.rating,
    required this.reviewCount,
    required this.palette,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Directionality(
        textDirection: TextDirection.ltr,
        child: _StarRow(rating: rating, palette: palette),
      ),
      const SizedBox(width: AiSummaryTokens.ratingStarToValueSpacing),
      Text(
        context.digits(rating.toStringAsFixed(1)),
        style: palette.ratingValueStyle,
      ),
      const SizedBox(width: AiSummaryTokens.ratingValueToCountSpacing),
      Text(
        context.digits('(${context.l10n.aiSummaryReviews(reviewCount)})'),
        style: palette.ratingCountStyle,
      ),
    ],
  );
}

class _StarRow extends StatelessWidget {
  final double rating;
  final AiSummaryPalette palette;

  const _StarRow({required this.rating, required this.palette});

  @override
  Widget build(BuildContext context) {
    const starCount = 5;
    final stars = <Widget>[];
    for (var i = 0; i < starCount; i++) {
      stars.add(_buildStar(i));
      if (i < starCount - 1) {
        stars.add(const SizedBox(width: AiSummaryTokens.ratingStarSpacing));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Widget _buildStar(int index) {
    // index is 0-based; a star at index `i` is considered filled if
    // rating >= i + 1, half-filled if rating >= i + 0.5, otherwise empty.
    final threshold = index + 1;
    if (rating >= threshold) {
      return Icon(
        Icons.star,
        size: AiSummaryTokens.ratingStarSize,
        color: palette.ratingStarFilled,
      );
    }
    if (rating >= threshold - 0.5) {
      return Icon(
        Icons.star_half,
        size: AiSummaryTokens.ratingStarSize,
        color: palette.ratingStarFilled,
      );
    }
    return Icon(
      Icons.star_border,
      size: AiSummaryTokens.ratingStarSize,
      color: palette.ratingStarEmpty,
    );
  }
}
