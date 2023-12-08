import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show CustomTextWidget, ErrorUnderWidget;

class CustomRadioButtonWidget extends StatelessWidget {
  final TextDirection? directionality;
  final bool selected;

  final String label;
  final TextStyle? labelStyle;

  /// Space between radio and label
  final double radioLabelSpace;

  final Color? radioColor;
  final Color? fillColor;
  final Color? borderColor;
  final double radioRadius;
  final dynamic radioValue;
  final dynamic radioGroupValue;

  final String? errorMsg;

  final Function(dynamic) onSelected;
  const CustomRadioButtonWidget({
    super.key,
    this.directionality,
    this.selected = false,
    //
    required this.label,
    this.labelStyle,
    //
    this.radioLabelSpace = 8.0,
    //
    this.radioRadius = 22.0,
    this.radioColor,
    this.fillColor,
    this.borderColor,
    required this.radioValue,
    required this.radioGroupValue,
    //
    this.errorMsg,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // In case of you need to set CheckBox on Left and Text on Right
      // change directionality of Row,
      // otherwise leave it as it is base app language
      textDirection: directionality ?? Directionality.of(context),
      child: Column(
        children: [
          // Radio Button
          Row(
            children: [
              // Radio
              _RadioWidget(
                radius: radioRadius,
                radioColor: radioColor ??
                    (isSelected ? AppColor.white : Colors.transparent),
                fillColor: _fillColor,
                borderColor: _borderColor,
                radioValue: radioValue,
                onSelected: onSelected,
              ),
              SizedBox(
                width: 6,
              ),
              // Label
              CustomTextWidget(
                label,
                textStyle: labelStyle ?? AppStyle.radioButtonStyle,
              ),
            ].addPadding(end: radioLabelSpace),
          ),
          // Error
          ErrorUnderWidget(errorText: errorMsg),
        ],
      ),
    );
  }

  bool get isSelected => selected || radioGroupValue == radioValue;

  Color get _fillColor =>
      isSelected ? radioColor ?? AppColor.primary900Light : Colors.transparent;
  Color get _borderColor =>
      isSelected ? fillColor ?? Colors.transparent : AppColor.primary900Light;
}

class _RadioWidget extends StatelessWidget {
  final double radius;
  final Color radioColor;
  final Color fillColor;
  final Color borderColor;
  final dynamic radioValue;
  final Function(dynamic) onSelected;
  const _RadioWidget({
    required this.radius,
    required this.radioColor,
    required this.fillColor,
    required this.borderColor,
    required this.radioValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // To cut effect color based radio radius
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      splashColor: AppColor.blue,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: () => onSelected(radioValue),
      child: Container(
        width: radius,
        height: radius,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        child: Container(
          width: radius / 3.0,
          height: radius / 3.0,
          decoration: BoxDecoration(color: radioColor, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
