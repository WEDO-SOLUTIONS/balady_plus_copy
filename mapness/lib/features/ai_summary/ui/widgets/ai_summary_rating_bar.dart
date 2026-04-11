import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_strings.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_tokens.dart';
import 'package:mapness/shared/providers/app_language.dart';

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
  final Language language;

  const AiSummaryRatingBar({
    required this.rating,
    required this.reviewCount,
    required this.language,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AiSummaryStrings(language);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: _StarRow(rating: rating),
        ),
        const SizedBox(width: AiSummaryTokens.ratingStarToValueSpacing),
        Text(
          rating.toStringAsFixed(1),
          style: AiSummaryTokens.ratingValueStyle,
        ),
        const SizedBox(width: AiSummaryTokens.ratingValueToCountSpacing),
        Text(
          '(${strings.reviews(reviewCount)})',
          style: AiSummaryTokens.ratingCountStyle,
        ),
      ],
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;

  const _StarRow({required this.rating});

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
      return const Icon(
        Icons.star,
        size: AiSummaryTokens.ratingStarSize,
        color: AiSummaryTokens.ratingStarFilled,
      );
    }
    if (rating >= threshold - 0.5) {
      return const Icon(
        Icons.star_half,
        size: AiSummaryTokens.ratingStarSize,
        color: AiSummaryTokens.ratingStarFilled,
      );
    }
    return const Icon(
      Icons.star_border,
      size: AiSummaryTokens.ratingStarSize,
      color: AiSummaryTokens.ratingStarEmpty,
    );
  }
}
