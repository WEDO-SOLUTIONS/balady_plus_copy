import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, BorderConversion, BorderType, UIHelper;
import '../../../shared_feature_exports.dart' show CustomTextWidget, DropDownItem, ErrorUnderWidget, WidgetLabel;

class CustomMaterialDropDownWidget extends StatelessWidget {
  final bool isRequired;
  final bool readOnly;
  final DropDownItem? initialValue;
  final List<DropDownItem> items;

  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;

  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final BorderType? borderType;
  final EdgeInsetsGeometry? padding;

  final String? errorMsg;

  final void Function(DropDownItem?) onSelected;
  final VoidCallback? onDisabledTapped;
  final VoidCallback? onTap;
  const CustomMaterialDropDownWidget({
    super.key,
    this.isRequired = true,
    this.readOnly = false,
    this.initialValue,
    required this.items,
    //
    this.label,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    //
    this.fillColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderType,
    this.padding,
    this.errorMsg,
    required this.onSelected,
    this.onTap,
    this.onDisabledTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label widget
        WidgetLabel(isRequired: isRequired, label: label, labelStyle: labelStyle),
        //! Drow-Down widget
        Container(
          padding: _padding,
          decoration: BoxDecoration(color: _fillColor, border: _border, borderRadius: _borderRadius),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DropDownItem>(
              isExpanded: true,
              isDense: true,
              icon: _ArrowIconWidget(readOnly: readOnly),
              value: initialValue,
              hint: CustomTextWidget(initialValue?.name ?? initialHint, textStyle: _hintStyle),
              onTap: onTap,
              menuMaxHeight: 400.0,
              items: items
                  .map(
                    (item) => DropdownMenuItem<DropDownItem>(
                      value: item,
                      child: CustomTextWidget(item.name, textStyle: _hintStyle),
                    ),
                  )
                  .toList(),
              onChanged: readOnly ? (_) => onDisabledTapped != null ? onDisabledTapped!() : null : onSelected,
            ),
          ),
        ),
        // Error widget
        ErrorUnderWidget(errorText: errorMsg),
      ],
    );
  }

  EdgeInsetsGeometry get _padding => padding ?? const EdgeInsets.all(UIHelper.middlePadding - 2.0);
  BorderType get _borderType => borderType ?? BorderType.outline;
  Color get _fillColor => readOnly ? AppColor.gray : fillColor ?? AppColor.white;
  BoxBorder? get _border => _borderType.boxBorder(color: borderColor ?? AppColor.gray);
  BorderRadiusGeometry? get _borderRadius => _borderType.boxBorderRadius(radius: borderRadius);

  TextStyle get _hintStyle => hintStyle ?? AppStyle.pickerStyle;
  String get initialHint => hintText ?? "selectFromHere".tr();
}

class _ArrowIconWidget extends StatelessWidget {
  final bool readOnly;
  const _ArrowIconWidget({required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Icon(Icons.arrow_back_ios_new, size: 14.0, color: readOnly ? AppColor.black : AppColor.gray),
    );
  }
}
