import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class RatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged? onRatingChanged;

  static const maxRating = 5;
  static const ratingItemSize = 47.0;

  const RatingBar({this.rating = 0, super.key, this.onRatingChanged});

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
                        package: PackageConfig.packageName,
                        isActive ? 'assets/images_svg/active_star.svg' : 'assets/images_svg/inactive_star.svg',
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
}
