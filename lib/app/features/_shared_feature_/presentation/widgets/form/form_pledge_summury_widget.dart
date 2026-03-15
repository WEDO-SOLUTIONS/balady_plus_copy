import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';

class FormPledgesSummuryWidget extends StatelessWidget {
  final String title;
  final String consent;
  final String consentcheck;
  final bool? currentValue;
  final Function onChanged;
  const FormPledgesSummuryWidget({
    super.key,
    required this.title,
    required this.consent,
    required this.consentcheck,
    this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelWidget(
      title: title,
      leading: SvgPicture.asset(IconPath.vdSummuryPledge),
      isExpanded: true,
      children: [
        CustomTextWidget(
          consent,
          fontColor: AppColor.blackModern700Light,
          maxLines: 90,
          height: 1.3,
          textAlign: TextAlign.start,
        ),
        CustomVerticalSpace(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Color(0x80E6EFEF), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Checkbox(
                value: currentValue ?? false,
                activeColor: AppColor.primary900Light,
                onChanged: (newVal) {
                  onChanged(newVal);
                },
              ),
              Flexible(
                child: CustomTextWidget(
                  consentcheck,
                  fontColor: AppColor.primary700Light,
                  fontSize: 12,
                  maxLines: 10,
                  fontWeight: AppFontWeight.semiBold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
