import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ComplianceRadioWidget extends StatelessWidget {
  const ComplianceRadioWidget({
    super.key,
    required this.feesStatus,
    required this.subtitle,
    required this.title,
  });
  final String title;
  final String subtitle;
  final String feesStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.blueSkyLight800,
            width: 1.5,
          )),
      child: RadioListTile(
        contentPadding: const EdgeInsets.all(10),
        groupValue: 0,
        onChanged: (value) {},
        value: 0,
        title: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                title,
                textStyle: AppStyle.complianceFirstSubmitTitleRadioStyle,
              ),
              CustomTextWidget(
                subtitle,
                textStyle: AppStyle.complianceFirstSubmitSubtitleStyle,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                'fees'.tr(),
                textStyle: AppStyle.complianceFeesStyle,
              ),
              CustomTextWidget(
                feesStatus,
                maxLines: 2,
                textStyle: AppStyle.complianceFeesStatusStyle,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
