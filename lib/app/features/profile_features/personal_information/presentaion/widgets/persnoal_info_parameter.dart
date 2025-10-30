import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

class PersonalInfoParameter extends StatelessWidget {
  final String title;
  final String value;

  const PersonalInfoParameter({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.primary50Light50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            textStyle: AppStyle.personalInfoParameterTitleTextStyle,
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            value,
            textStyle: AppStyle.personalInfoParameterValueTextStyle,
          ),
        ],
      ),
    );
  }
}
