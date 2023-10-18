import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomTextWidget, CustomSvgIconWidget;
import '../../../facility_qr_exports.dart' show RateAndReviewWidget;

class FacilityRatingWidget extends StatelessWidget {
  final double rating;
  final int reviews;

  const FacilityRatingWidget(
      {super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 67,
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        FacilityItemRatingComponent(
          rating: rating,
          reviews: reviews,
        )
      ]),
    );
  }
}

class FacilityItemRatingComponent extends StatelessWidget {
  final double rating;
  final int reviews;

  const FacilityItemRatingComponent(
      {super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            "qr_facility_rating".tr(),
            fontColor: AppColor.blackModern600Light,
            fontSize: 13,
            fontWeight: AppFontWeight.bold,
          ),
          CustomVerticalSpace(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomSvgIconWidget(IconPath.qrRatingStarIcon),
              const CustomHorizontalSpace(width: 5),
              CustomTextWidget(
                "$rating/5",
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.medium,
                fontSize: 14,
              ),
              const CustomHorizontalSpace(width: 5),
              CustomTextWidget(
                ("($reviews)"),
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.medium,
                fontSize: 14,
              ),
            ],
          )
        ],
      ),
    );
  }
}
