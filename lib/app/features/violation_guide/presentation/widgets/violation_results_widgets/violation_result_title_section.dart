import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationResultsSectionTitle extends StatelessWidget {
  const ViolationResultsSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      'violation_results_page_section_title'.tr(),
      textStyle: AppStyle.violationResultsSectionStyle,
    );
  }
}
