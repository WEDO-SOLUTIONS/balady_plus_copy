import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'compliance_title_widget.dart';

class ComplianceConsent extends StatelessWidget {
  final String body;
  final bool? agreement;
  final Function onChanged;

  const ComplianceConsent(
      {super.key,
      required this.body,
      required this.agreement,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVerticalSpace(height: 16),
        ComplianceSubmitTitle(
          title: 'vd_pledges'.tr(),
          subtitle: "",
        ),
        CustomTextWidget(
          body,
          fontColor: AppColor.blackModern700Light,
          maxLines: 90,
          height: 1.3,
          textAlign: TextAlign.start,
        ),
        CustomVerticalSpace(height: 8),
        Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Color(0x80E6EFEF),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Checkbox(
                  value: agreement ?? false,
                  activeColor: AppColor.primary900Light,
                  onChanged: (newVal) {
                    onChanged(newVal);
                  },
                ),
                Flexible(
                  child: CustomTextWidget(
                    ("vd_consent_check").tr(),
                    fontColor: AppColor.primary700Light,
                    fontSize: 12,
                    maxLines: 10,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
