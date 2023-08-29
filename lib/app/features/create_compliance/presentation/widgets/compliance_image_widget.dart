import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ComplianceImageWidget extends StatelessWidget {
  const ComplianceImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(3.9),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Scroll horizontally
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  ImagePath.complianceFirstImage,
                  width: 149,
                ),
                const SizedBox(
                  width: 6,
                ),
                Image.asset(
                  ImagePath.complianceSecondImage,
                  width: 149,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              'clauses_image_text'.tr(),
              textStyle: AppStyle.complianceClausesTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleRatioOption(
                  value: 1,
                  title: 'clauses_option1'.tr(),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  titleStyle: AppStyle.complianceClausesOptionStyle,
                ),
                const SizedBox(
                  width: 6,
                ),
                SingleRatioOption(
                  title: 'clauses_option2'.tr(),
                  value: 2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  titleStyle: AppStyle.complianceClausesOptionStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
