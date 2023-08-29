import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FifthComplianceSubmitStep extends StatelessWidget {
  const FifthComplianceSubmitStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComplianceSubmitTitle(
            title: 'compliance_complain_title'.tr(),
            subtitle: 'compliance_complain_subtitle'.tr(),
          ),
          CustomTextWidget(
            'compliance_image_upload_title'.tr(),
            textStyle: AppStyle.complianceDocumentTitleStyle,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedIconButtonWidget.upload(onPressed: () {}),
          SizedBox(
            height: 32,
          ),
          CustomTextWidget(
            'compliance_notes_title'.tr(),
            textStyle: AppStyle.complianceDocumentTitleStyle,
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 2,
                  color: AppColor.blueSkyLight800,
                )),
            child: CustomTextWidget(
              'comliance_message_hint'.tr(),
              textStyle: AppStyle.complianceSubtitleStyle,
              textAlign: TextAlign.right,
              maxLines: 4,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          ElevatedButtonWidget.next(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
