import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class ComplianceSubmitTitle extends StatelessWidget {
  const ComplianceSubmitTitle({
    super.key,
    required this.subtitle,
    required this.title,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          textStyle: AppStyle.complianceTitleStyle,
        ),
        const SizedBox(
          height: 7,
        ),
        CustomTextWidget(
          subtitle,
          textStyle: AppStyle.complianceSubtitle,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
      ],
    );
  }
}
