import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class SelfRatingResultSectionItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  final Color titleColor;
  const SelfRatingResultSectionItem(
      {super.key,
      required this.icon,
      required this.subTitle,
      required this.title,
      this.titleColor = AppColor.primary900Light});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget(
              title,
              fontColor: titleColor,
              fontSize: 30,
              fontWeight: AppFontWeight.bold,
            ),
            CustomVerticalSpace(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 16,
                  height: 16,
                ),
                CustomHorizontalSpace(width: 4),
                CustomTextWidget(
                  subTitle,
                  fontColor: AppColor.blackModern900Light,
                  fontSize: 14,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
