import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationAddressSectionWidget extends StatelessWidget {
  const ViolationAddressSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.grayLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              'address_1'.tr(),
              textStyle: AppStyle.violationLocationAdressStyle,
            ),
            Row(
              children: [
                const CustomSvgIconWidget(IconPath.location),
                CustomTextWidget(
                  'khobar_location'.tr(),
                  textStyle: AppStyle.violationLocationMapStyle,
                ),
              ],
            ),
          ],
        ),
        const CustomSvgIconWidget(
          IconPath.arrowLeft,
        ),
      ]),
    );
  }
}
