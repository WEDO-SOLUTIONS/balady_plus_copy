// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class PostersLicenseItemWidget extends StatelessWidget {
  final String? licenseNo;
  final String? location;
  final String? status;
  final String? expiryDate;
  final Function? onDelete;
  const PostersLicenseItemWidget(
      {Key? key,
      this.licenseNo,
      this.location,
      this.status,
      this.expiryDate,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: onDelete != null
            ? const EdgeInsets.only(bottom: 16, right: 16)
            : const EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: AppColor.redBrown,
                ),
                onPressed: () {
                  if (onDelete != null) onDelete!();
                },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            'license_no'.tr(),
                            textStyle:
                                AppStyle.complianceTitleLabelLicenseStyle,
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
                            'loaction'.tr(),
                            textStyle:
                                AppStyle.complianceTitleLabelLicenseStyle,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CustomTextWidget(
                            location ?? "",
                            textStyle: AppStyle.complianceSubtitleLicenseStyle,
                            maxLines: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            'license_status'.tr(),
                            textStyle:
                                AppStyle.complianceTitleLabelLicenseStyle,
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
                            textStyle:
                                AppStyle.complianceTitleLabelLicenseStyle,
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
                ),
              ],
            ),
          ],
        ));
  }
}
