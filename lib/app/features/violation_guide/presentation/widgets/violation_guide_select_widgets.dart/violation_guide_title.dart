import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationGuideSelectTitle extends StatelessWidget {
  const ViolationGuideSelectTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          'violation_select_guide_title_page'.tr(),
          textStyle: AppStyle.violationSelectGuideTitlePageStyle,
        ),
        CustomTextWidget(
          'violation_select_guide_subtitle_page'.tr(),
          textStyle: AppStyle.violationSelectGuideSubtitleStyle,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
