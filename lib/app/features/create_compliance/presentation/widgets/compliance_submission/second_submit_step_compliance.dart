import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SecondSubmissonCompliance extends StatelessWidget {
  const SecondSubmissonCompliance({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComplianceSubmitTitle(
            title: 'user_info_details_title'.tr(),
            subtitle: 'user_info_details_subtitle'.tr(),
          ),
          const SizedBox(
            height: 7,
          ),
          CustomTextFieldWidget(
            fillColor: AppColor.scaffoldBackground,
            label: 'user_name_label'.tr(),
            labelStyle: AppStyle.complianceLabelStyle,
            hintText: 'name_ahmad'.tr(),
            hintStyle: AppStyle.complianceSubtitleStyle,
            borderRadius: 6,
            borderColor: const Color(0xffD4D4D8),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTextWidget(
            'phone_number_label'.tr(),
            textStyle: AppStyle.complianceLabelStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 1,
                  color: const Color(0xffD4D4D8),
                )),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        '0581802447',
                        textStyle: AppStyle.complianceSubtitleStyle,
                      ),
                      CustomTextButtonWidget(
                        text: 'verifyButton'.tr(),
                        textStyle: AppStyle.comlianceImageUploadStyle,
                      ),
                    ],
                  )),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          ElevatedButtonWidget.next(
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
