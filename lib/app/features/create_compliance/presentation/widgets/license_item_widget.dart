import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ComplianceLicenseItemWidget extends StatelessWidget {
  final String? licenseNo;
  final String? licenseType;
  final String? municipality;
  final String? status;
  final String? dueDate;
  final String? expiryDate;
  const ComplianceLicenseItemWidget({
    super.key,
    this.dueDate,
    this.licenseNo,
    this.licenseType,
    this.municipality,
    this.expiryDate,
    this.status,
  });

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
                      'license_type'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      licenseType ?? "",
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
                      'userLicensesLicenseDetailsMunicipalWord'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      municipality ?? "",
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
                      "issue_data".tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      dueDate ?? "",
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
                      "expiry_data".tr(),
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
