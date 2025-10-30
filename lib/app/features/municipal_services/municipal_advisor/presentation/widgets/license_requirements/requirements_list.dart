import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';

class RequirementsList extends StatelessWidget {
  final int? number;
  final String title;
  final List<String> requirements;

  const RequirementsList({
    super.key,
    this.number,
    required this.title,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (number != null)
            TextSpan(
              text: '$number. $title\n',
              style: AppStyle.textFieldTitleTextStyle.copyWith(
                color: AppColor.primary900Light,
              ),
            ),
          for (final requirement in requirements)
            TextSpan(
              text: '- $requirement \n',
              style: AppStyle.lightTextStyle,
            ),
          if (requirements.isEmpty)
            TextSpan(
              text: '${"noData".tr()}\n',
              style: AppStyle.lightTextStyle,
            ),
        ],
      ),
    );
  }
}
