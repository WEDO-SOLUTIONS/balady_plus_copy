import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class ExtraActivityCard extends StatelessWidget {
  const ExtraActivityCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 24),
      decoration:  BoxDecoration(
        borderRadius:
        const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            "نشاط ايزيك",
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "بيع بالتجزئه",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
          SizedBox(height: 16),
          CustomTextWidget(
            "النشاط التفصيلي",
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "بيع بالتجزئه",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
          SizedBox(height: 16),
          CustomTextWidget(
            "المساحه الكليه للمحل",
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "16.0000 متر مربع",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
        ],
      ),
    );
  }
}
