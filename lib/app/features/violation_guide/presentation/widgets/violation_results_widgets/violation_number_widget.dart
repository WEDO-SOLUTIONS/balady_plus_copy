import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationNumberResultWidget extends StatelessWidget {
  const ViolationNumberResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.blueSkyLight800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CustomTextWidget(
          'result_violation_count_option'.tr(),
          textStyle: AppStyle.violationResultsHeaderStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget(
              '60'.tr(),
              textStyle: AppStyle.violationNumberStyle,
            ),
            const SizedBox(
              width: 5,
            ),
            CustomTextWidget(
              "result-1".tr(),
              textStyle: AppStyle.violationStyle,
            ),
          ],
        )
      ]),
    );
  }
}
