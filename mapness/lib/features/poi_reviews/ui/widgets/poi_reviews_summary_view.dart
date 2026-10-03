import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:mapness/features/poi_reviews/ui/poi_reviews_format.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_review_stars.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Average rating with stars and a 5..1 histogram.
class PoiReviewsSummaryView extends StatelessWidget {
  final PoiReviewsSummary summary;

  const PoiReviewsSummaryView({required this.summary, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                formatPoiRating(summary.average, l10n),
                style: context.textStyles.h1SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: Spacing.$1x),
              PoiReviewStars(rating: summary.average, size: 16),
              const SizedBox(height: Spacing.$1_5x),
              Text(
                l10n.poiReviewsRatingsCount(summary.ratingsCount),
                style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
              ),
            ],
          ),
          const SizedBox(width: Spacing.$6x),
          Expanded(
            child: Column(
              children: [
                for (var stars = 5; stars >= 1; stars--)
                  _HistogramRow(
                    stars: stars,
                    fraction: summary.ratingsCount == 0 ? 0 : summary.countFor(stars) / summary.ratingsCount,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistogramRow extends StatelessWidget {
  final int stars;
  final double fraction;

  const _HistogramRow({required this.stars, required this.fraction});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: Spacing.$4x,
    child: Row(
      children: [
        SizedBox(
          width: Spacing.$3x,
          child: Text(
            '$stars',
            textAlign: TextAlign.center,
            style: context.textStyles.captionSmallRegular.copyWith(color: context.colors.foregroundSoft),
          ),
        ),
        const SizedBox(width: Spacing.$1_5x),
        Expanded(
          child: Container(
            height: Spacing.$1_5x,
            decoration: BoxDecoration(
              color: context.colors.neutralContainerDefault,
              borderRadius: BorderRadius.circular(RadiusBorder.full),
            ),
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: fraction,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.accentDefault,
                  borderRadius: BorderRadius.circular(RadiusBorder.full),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
