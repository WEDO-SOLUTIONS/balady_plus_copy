// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class PostersLicenseItemWidget extends StatelessWidget {
  final String? licenseNo;
  final String? location;
  final String? status;
  final String? expiryDate;
  const PostersLicenseItemWidget({
    Key? key,
    this.licenseNo,
    this.location,
    this.status,
    this.expiryDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'license_no'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      licenseNo ?? "",
                      textStyle: AppStyle.complianceSubtitleLicenseStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'license_status'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      status ?? "",
                      textStyle: AppStyle.complianceSubtitleLicenseStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'loaction'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      location ?? "",
                      textStyle: AppStyle.complianceSubtitleLicenseStyle,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'license_status'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      status ?? "",
                      textStyle: AppStyle.complianceSubtitleLicenseStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'license_end_date'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      expiryDate ?? "",
                      textStyle: AppStyle.complianceSubtitleLicenseStyle,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
