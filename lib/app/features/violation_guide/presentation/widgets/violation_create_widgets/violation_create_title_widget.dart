import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationCreateTitleWidget extends StatelessWidget {
  const ViolationCreateTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          'violation_create_title'.tr(),
          textStyle: AppStyle.violationCreateTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextWidget(
          'violation_create_subtitle'.tr(),
          textStyle: AppStyle.violatioCreateSubtitle,
          maxLines: 6,
          textAlign: TextAlign.center,
          height: 1.4,
        ),
      ],
    );
  }
}
