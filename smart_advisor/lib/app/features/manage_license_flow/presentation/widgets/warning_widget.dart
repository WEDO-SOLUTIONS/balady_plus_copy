import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';

class WarningWidget extends StatelessWidget {
  final bool? extraContainer;
  final String? warningText;
  final String? warningDescriptionText;
  const WarningWidget(
      {super.key,
      this.extraContainer = false,
      this.warningDescriptionText,
      this.warningText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE7DAD9),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                  'packages/smart_advisor/smart_advisor_assets/icons/svg/warning.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(
                'تنبيه',
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'التكاليف المعروضة للتجديد فقط، يوجد تكاليف اخرى توضح عند بدء الخدمة',
            style: AppStyle.footNoteRomanStyle
                .copyWith(color: AppColor.textSecondaryColor),
            textAlign: TextAlign.right,
          ),
          extraContainer!
              ? Container(
                  height: 110,
                  padding: const EdgeInsets.only(top: 14, right: 16, left: 26),
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEFDDD8)),
                    color: const Color(0xffF7F3F2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(warningText!,
                          textAlign: TextAlign.start,
                          style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textPrimaryColor,
                            fontSize: 14,
                            height: 1.6,
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          // BaladyServices.openIssueLicense();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  warningDescriptionText!,
                                  style: AppStyle.footNoteRomanStyle.copyWith(
                                    color: AppColor.statusAttentionColor,
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(IconPath.stepArrowIcon)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
