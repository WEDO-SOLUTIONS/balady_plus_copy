import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SelfRatingMainTitleWidget extends StatelessWidget {
  const SelfRatingMainTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          'self_review'.tr(),
          textStyle: AppStyle.violationSelectGuideTitlePageStyle,
        ),
        CustomTextWidget(
          'self_review_subtitle'.tr(),
          textStyle: AppStyle.violationSelectGuideSubtitleStyle,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
