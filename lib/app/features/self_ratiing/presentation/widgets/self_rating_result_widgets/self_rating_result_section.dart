import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_result_widgets/self_rating_result_section_item.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/rating_self_success_result.dart';

class SelfRatingResultSection extends StatelessWidget {
  final RatingSelfSuccessResult result;
  const SelfRatingResultSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 173,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: ShapeDecoration(
        color: AppColor.primary100Light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomTextWidget(
          "self_rating_result_title".tr(),
          fontColor: AppColor.blackModern900Light,
          fontSize: 15,
          fontWeight: AppFontWeight.bold,
        ),
        CustomVerticalSpace(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelfRatingResultSectionItem(
              subTitle: "compliance".tr(),
              title: "${result.percentage}%",
              icon: IconPath.star,
            ),
            if (result.totalViolation != 0) ...[
              CustomHorizontalSpace(width: 8),
              SelfRatingResultSectionItem(
                subTitle: "violations_text".tr(),
                title: result.totalViolation.toString(),
                titleColor: AppColor.blue900Light,
                icon: IconPath.dangerIcon,
              ),
            ]
          ],
        ),
      ]),
    );
  }
}
