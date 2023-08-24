import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationLocationTitleWidget extends StatelessWidget {
  const ViolationLocationTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          'location_confirm'.tr(),
          textStyle: AppStyle.violationCreateTitle,
        ),
        CustomTextWidget(
          'violence_location_subtitle'.tr(),
          textStyle: AppStyle.violatioCreateSubtitle,
        ),
      ],
    );
  }
}
