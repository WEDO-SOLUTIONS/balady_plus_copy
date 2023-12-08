import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';

class TitleCostWidet extends StatelessWidget {
  final String title;
  final num cost;
  const TitleCostWidet({
    super.key,
    required this.title,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextWidget(
            title,
            textStyle: AppStyle.costTitleTextStyle,
          ),
        ),
        CustomTextWidget(
          "${cost.toStringAsFixed(2)} ${'sar'.tr()}",
          textStyle: AppStyle.costTextStyle,
        )
      ],
    );
  }
}
