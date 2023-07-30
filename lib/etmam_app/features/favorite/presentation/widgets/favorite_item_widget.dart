import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, ImagePath, IconPath, AppFontWeight;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        RatingEvaluationWidget,
        ServiceProviderLogo;
import 'package:flutter/material.dart';

class FavoriteItemWidget extends StatelessWidget {
  const FavoriteItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-4, 8),
                blurRadius: 8,
                spreadRadius: 0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomVerticalSpace(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ServiceProviderLogo(
                image: ImagePath.service_provider_logo,
              ),
              CustomIconButtonWidget(
                padding: EdgeInsets.zero,
                btnPressed: () {},
                icon: const CustomSvgIconWidget(
                  IconPath.favoriteHeartIcon,
                  iconWidth: 14,
                  iconHeight: 19,
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 7, top: 16),
            child: CustomTextWidget(
              "مكتب البعد التصميمي للاستشارات",
              fontSize: 14,
              fontColor: AppColor.black,
              fontWeight: AppFontWeight.medium,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          const RatingEvaluationWidget(
            ratingColor: AppColor.blue700,
            rating: 6.6,
            totalEvaluation: 900,
          ),
        ],
      ),
    );
  }
}
