import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, WidgetConversion;
import '../../../shared_feature_exports.dart' show CustomTextWidget;

class LabelValueComponent extends StatelessWidget {
  final String label;
  final TextStyle? labelTextStyle;
  final String value;
  final TextStyle? valueTextStyle;
  const LabelValueComponent({
    super.key,
    required this.label,
    this.labelTextStyle,
    required this.value,
    this.valueTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        CustomTextWidget(
          label,
          textStyle: labelTextStyle ?? AppStyle.mainTextSecondaryStyle.copyWith(color: AppColor.gray),
        ),
        // Value
        Expanded(
          child: CustomTextWidget(
            value,
            textStyle: valueTextStyle ?? AppStyle.mainTextSecondaryStyle.copyWith(color: AppColor.black),
          ),
        ),
      ].addPadding(end: 8.0),
    );
  }
}
