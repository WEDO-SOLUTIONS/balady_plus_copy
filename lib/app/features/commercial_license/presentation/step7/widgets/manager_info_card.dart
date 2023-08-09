import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

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
              CustomSvgIconWidget(IconPath.clipboard),
              SizedBox(width: 4),
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
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "user_data_applicant_name".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      'AhmadKhaled'.tr(),
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
                      "sex".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "male".tr(),
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
                      "nationality".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "personal_saudi".tr(),
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
                      "employment".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "accountant".tr(),
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
