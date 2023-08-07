import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class OwnerInfoCard extends StatelessWidget {
  const OwnerInfoCard({
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
                  "owner_card".tr(),
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
                      "owner_name".tr(),
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
                      "owner_number".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "5246854724",
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
                      "owner_id".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "837463455486",
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
                      "owner_email".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      "example@example.com",
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
