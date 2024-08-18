import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';

class ManagerInfoCard extends StatelessWidget {
  const ManagerInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomSvgIconWidget(IconPath.clipboard),
              const SizedBox(width: 4),
              Flexible(
                child: CustomTextWidget(
                  "managerLocation".tr(),
                  fontColor: AppColor.blackModern600Light,
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "name".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "احمد خالد",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "personal_gender".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "ذكر",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "الجنسيه",
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "سعودي",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "المهنه",
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "محاسب",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
