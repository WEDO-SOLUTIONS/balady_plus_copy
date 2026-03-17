import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show CustomTextWidget, ErrorUnderWidget;

class CustomCheckBoxWidget extends StatelessWidget {
  final TextDirection? directionality;
  final bool selected;

  /// Space between radio and label
  final double checkBoxLabelSpace;

  final String label;
  final TextStyle? labelStyle;

  final double radius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? checkColor;

  final String? errorMsg;

  final void Function(bool) onChanged;
  const CustomCheckBoxWidget({
    super.key,
    this.directionality,
    required this.selected,
    //
    required this.label,
    this.labelStyle,
    //
    this.checkBoxLabelSpace = 10.0,
    //
    this.radius = 4.0,
    this.borderColor,
    this.fillColor,
    this.checkColor,
    //
    this.errorMsg,
    required this.onChanged,
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
          // CheckBox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Check-Box
              _CheckWidget(
                selected: selected,
                radius: radius,
                checkColor: checkColor ?? AppColor.white,
                fillColor: _fillColor,
                borderColor: _borderColor,
                onChanged: onChanged,
              ),
              // Label
              Expanded(
                child: CustomTextWidget(
                  label,
                  textAlign: TextAlign.start,
                  textStyle: labelStyle ?? AppStyle.checkBoxStyle,
                ),
              ),
            ].addPadding(end: checkBoxLabelSpace),
          ),
          // Error
          ErrorUnderWidget(errorText: errorMsg),
        ],
      ),
    );
  }

  Color get _fillColor =>
      selected ? fillColor ?? AppColor.primary900Light : Colors.transparent;
  Color get _borderColor =>
      selected ? borderColor ?? Colors.transparent : AppColor.gray;
}

class _CheckWidget extends StatelessWidget {
  final bool selected;
  final double radius;
  final Color checkColor;
  final Color fillColor;
  final Color borderColor;
  final void Function(bool) onChanged;
  const _CheckWidget({
    required this.selected,
    required this.radius,
    required this.checkColor,
    required this.fillColor,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      splashColor: AppColor.blue,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: () => onChanged(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 20.0,
        height: 20.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor),
        ),
        child:
            selected ? Icon(Icons.check, size: 18.0, color: checkColor) : null,
      ),
    );
  }
}
