import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationDetailsWidget extends StatelessWidget {
  const ViolationDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        Container(
          width: 310,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor.grayLight100,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomTextWidget(
              'violation_approved_text'.tr(),
              maxLines: 2,
              textStyle: AppStyle.violationListTitleStyle,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  'start_from'.tr(),
                  textStyle: AppStyle.violationStartFromStyle,
                ),
                Row(
                  children: [
                    CustomTextWidget(
                      '10000'.tr(),
                      textStyle: AppStyle.violationNumberStyle1,
                    ),
                    CustomTextWidget(
                      'riyalperWorker'.tr(),
                      textStyle: AppStyle.violationRiyalPerWorkerStyle,
                    ),
                  ],
                ),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
