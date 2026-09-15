import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, DateForm;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class DateFormCell extends StatelessWidget {
  final DateForm value;
  final DateForm groupValue;
  final Function(DateForm?) onChanged;

  const DateFormCell({super.key, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          height: 48,
          decoration: BoxDecoration(color: AppColor.primary50Light50, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              RadioGroup<DateForm>(
                groupValue: groupValue,
                onChanged: onChanged,
                child: Radio<DateForm>(value: value, activeColor: AppColor.primary700Light),
              ),
              CustomTextWidget(
                value == DateForm.gregorian ? "gregorian".tr() : "hijri".tr(),
                textStyle: AppStyle.dropDownValueTextStyle,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
