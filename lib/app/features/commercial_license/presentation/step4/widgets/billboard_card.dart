import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class BillboardCard extends StatelessWidget {
  const BillboardCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            'BoardType'.tr(),
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "Advertising".tr(),
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
          SizedBox(height: 16),
          CustomTextWidget(
            'lbl_painting_space'.tr(),
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            'square_meter_16'.tr(),
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
        ],
      ),
    );
  }
}
