import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_reviews/state/poi_reviews_providers.dart';
import 'package:mapness/features/poi_reviews/ui/poi_reviews_format.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_review_stars.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// "★★★★★ 4.9  128 ratings" row under the POI title.
class RatingComponent extends ConsumerWidget {
  static const _height = 20.0;

  final int objectId;

  const RatingComponent({required this.objectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(poiReviewsSummaryProvider(objectId));
    final value = summary.value;
    if (value == null) {
      // Reserve the row while loading so the header doesn't jump once the rating arrives.
      return SizedBox(height: summary.isLoading ? _height : 0);
    }
    if (value.ratingsCount == 0) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    return SizedBox(
      height: _height,
      child: Row(
        children: [
          PoiReviewStars(rating: value.average),
          const SizedBox(width: Spacing.$1_5x),
          Text(
            formatPoiRating(value.average, l10n),
            style: context.textStyles.bodySmallMedium.copyWith(color: context.colors.foregroundDefault),
          ),
          const SizedBox(width: Spacing.$2x),
          Flexible(
            child: Text(
              l10n.poiReviewsRatingsCount(value.ratingsCount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ),
        ],
      ),
    );
  }
}
