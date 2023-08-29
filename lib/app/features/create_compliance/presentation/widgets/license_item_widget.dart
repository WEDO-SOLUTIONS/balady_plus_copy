import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ComplianceLicenseItemWidget extends StatelessWidget {
  const ComplianceLicenseItemWidget({super.key});

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
                      'license_1'.tr(),
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
                      '5/1/2021'.tr(),
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
                      'due_license'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      '5/1/2021'.tr(),
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
                      'west_dammam'.tr(),
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
                      '5/1/2021'.tr(),
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
                      'expiry_date'.tr(),
                      textStyle: AppStyle.complianceTitleLabelLicenseStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextWidget(
                      '5/1/2021'.tr(),
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
