import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_action_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_added_action_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_futher_actions.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_image_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ApprovedViolationDetails extends StatelessWidget {
  const ApprovedViolationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomTextWidget(
              'violation_payment_text'.tr(),
              textStyle: AppStyle.approvedViolationLabelStyle,
            ),
            Row(
              children: [
                CustomTextWidget(
                  '500'.tr(),
                  textStyle: AppStyle.approvedViolationSubtitle,
                ),
                const SizedBox(
                  width: 3,
                ),
                CustomTextWidget(
                  'riyalperWorker'.tr(),
                  textStyle: AppStyle.violationRiyalPerWorkerStyle,
                ),
              ],
            ),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        const ViolationActionWidget(),
        const SizedBox(
          height: 10,
        ),
        const ViolationFurtherAction(),
        const SizedBox(
          height: 10,
        ),
        const ViolationAddedActionWidget(),
        const SizedBox(
          height: 10,
        ),
        const ViolationImageWidget(),
      ],
    );
  }
}
