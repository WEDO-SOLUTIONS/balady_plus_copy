import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_review_tile.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiMyReviewCard extends StatelessWidget {
  final PoiReview review;
  final VoidCallback onEdit;

  const PoiMyReviewCard({required this.review, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(Spacing.$4x),
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.poiReviewsYourReview,
          style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$3x),
        PoiReviewTile(
          review: review,
          avatar: const PoiMyAvatar(),
          authorName: context.l10n.poiReviewsYou,
          action: PoiReviewTextAction(label: context.l10n.edit, onTap: onEdit),
        ),
      ],
    ),
  );
}
