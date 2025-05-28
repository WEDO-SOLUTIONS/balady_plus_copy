import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class RatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged? onRatingChanged;

  static const maxRating = 5;
  static const ratingItemSize = 47.0;

  const RatingBar({
    this.rating = 0,
    super.key,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: ratingItemSize,
        child: Center(
          child: ListView.builder(
              itemCount: maxRating,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final isActive = index < rating;
                return Material(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    splashColor: context.colorsV2.foregroundSoft.withOpacity(0.01),
                    onTap: () => onRatingChanged?.call(index + 1),
                    child: SizedBox(
                      width: ratingItemSize,
                      height: ratingItemSize,
                      child: SvgPicture.asset(
                        width: ratingItemSize,
                        height: ratingItemSize,
                        key: ValueKey('rating_star-$index-$isActive'),
                        isActive ? Assets.imagesSvg.activeStar.keyName : Assets.imagesSvg.inactiveStar.keyName,
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
}
