// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';

class PostersLicenseItemWidget extends StatelessWidget {
  final String? licenseNo;
  final String? location;
  final String? status;
  final String? expiryDate;
  final Function? onDelete;
  final Color? backgroundColor;
  const PostersLicenseItemWidget(
      {Key? key,
      this.licenseNo,
      this.location,
      this.status,
      this.expiryDate,
      this.onDelete,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: onDelete != null
            ? const EdgeInsets.only(bottom: 16, right: 16)
            : const EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: ShapeDecoration(
          color: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DrawIconBasedTypeWidget(
                      icon: IconPath.vdSummuryDesc,
                      iconSize: 20.0,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomTextWidget(
                      ("license".tr()),
                      maxLines: 2,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: Color(0xFF52525B),
                    ),
                  ],
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xffD86581),
                    ),
                    onPressed: () {
                      if (onDelete != null) onDelete!();
                    },
                  ),
              ],
            ),
            if (onDelete == null)
              SizedBox(
                height: 16,
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
                            (status) ?? "",
                            maxLines: 2,
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
