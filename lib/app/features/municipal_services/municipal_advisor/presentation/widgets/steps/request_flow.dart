import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class RequestFlow extends StatelessWidget {
  final List<RequestStepModel> steps;

  const RequestFlow({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            TextSpan(
              text: '\n${'stage'.tr()} #${steps[i].index}:\n',
              style: AppStyle.textFieldTitleTextStyle.copyWith(
                color: AppColor.primary800Light,
              ),
            ),
            TextSpan(
              text: '${steps[i].stepName}\n',
              style: AppStyle.lightTextStyle,
            ),
          ],
          if (steps.isEmpty)
            TextSpan(
              text: '${"noData".tr()}\n',
              style: AppStyle.lightTextStyle,
            ),
        ],
      ),
    );
  }
}
