import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';

/// Points promised for the first review; rewards don't exist yet, the value is from the design.
const poiReviewRewardPoints = 3;

/// "Rate & review" prompt; a tapped star opens the rate sheet with that rating preselected.
class PoiRateCard extends StatelessWidget {
  final ValueChanged<int> onRate;

  const PoiRateCard({required this.onRate, super.key});

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$4x, Spacing.$4x, Spacing.$3x),
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Column(
          children: [
            Text(
              context.l10n.poiReviewsRateAndReview,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
            ),
            const SizedBox(height: Spacing.$2x),
            RatingBar(onRatingChanged: (value) => onRate(value as int)),
            const SizedBox(height: Spacing.$1x),
            Text(
              context.l10n.poiReviewsTapToRate,
              textAlign: TextAlign.center,
              style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ],
        ),
      ),
      PositionedDirectional(
        top: -Spacing.$2_5x,
        end: Spacing.$1x,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x, vertical: Spacing.$0_5x),
          decoration: BoxDecoration(
            color: context.colors.accentDefault,
            borderRadius: BorderRadius.circular(RadiusBorder.full),
          ),
          child: Text(
            context.l10n.poiReviewsRewardPoints(poiReviewRewardPoints),
            style: context.textStyles.captionMediumSemiBold.copyWith(color: context.colors.accentOnAccent),
          ),
        ),
      ),
    ],
  );
}
