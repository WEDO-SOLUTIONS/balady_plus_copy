import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationActionWidget extends StatelessWidget {
  const ViolationActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 135,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(16)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextWidget(
              'action'.tr(),
              textStyle: AppStyle.approvedViolationLabelStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              'warning_done'.tr(),
              textStyle: AppStyle.approvedViolationSubtitle,
            ),
          ]),
        ),
        Container(
          width: 135,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(16)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextWidget(
              'duration_fix'.tr(),
              textStyle: AppStyle.approvedViolationLabelStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              '14days'.tr(),
              textStyle: AppStyle.approvedViolationSubtitle,
            ),
          ]),
        ),
      ],
    );
  }
}
