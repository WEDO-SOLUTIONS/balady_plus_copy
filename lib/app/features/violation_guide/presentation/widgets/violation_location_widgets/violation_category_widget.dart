import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';

class ViolationCategoryWidget extends StatelessWidget {
  const ViolationCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.grayLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CustomTextWidget(
          'dammam_balady'.tr(),
          textStyle: AppStyle.violationLocationDammamMapStyle,
        ),
        CustomTextWidget(
          'first_category'.tr(),
          textStyle: AppStyle.violationLocationCategoryMapStyle,
        )
      ]),
    );
  }
}
