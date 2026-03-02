import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, BorderConversion, BorderType, ContextConversion, UIHelper;
import '../../../shared_feature_exports.dart'
    show
        BottomSheetDialog,
        CustomCupertinoPickerWidget,
        CustomTextWidget,
        DropDownItem,
        ErrorUnderWidget,
        IconButtonWidget,
        WidgetLabel;

class CustomCupertinoDropDownWidget extends StatelessWidget {
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
  final VoidCallback? onTap;
  final VoidCallback? onDisabledTapped;
  const CustomCupertinoDropDownWidget({
    super.key,
    this.isRequired = true,
    this.readOnly = false,
    this.initialValue,
    required this.items,
    this.label,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
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
        WidgetLabel(
          isRequired: isRequired,
          label: label,
          labelStyle: labelStyle,
        ),
        //! Drow-Down widget
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: readOnly
              ? onDisabledTapped
              : () async {
                  if (onTap != null) onTap!();
                  await showDropDown(context);
                },
          child: Container(
            padding: _padding,
            decoration: BoxDecoration(
              color: _fillColor,
              border: _border,
              borderRadius: _borderRadius,
            ),
            child: LayoutBuilder(
              builder: (_, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hint widget
                    SizedBox(
                      width: constraints.maxWidth * 0.90,
                      child: CustomTextWidget(
                        initialValue?.name ?? initialHint,
                        textStyle: _hintStyle,
                      ),
                    ),
                    // Arrow widget
                    Align(
                      // color: Colors.red,
                      alignment: AlignmentDirectional.centerStart,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.05,
                        child: _ArrowIconWidget(readOnly: readOnly),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Error widget
        ErrorUnderWidget(errorText: errorMsg),
      ],
    );
  }

  EdgeInsetsGeometry get _padding =>
      padding ??
      const EdgeInsets.symmetric(
        horizontal: UIHelper.middlePadding - 2.0,
        vertical: UIHelper.middlePadding + 1.0,
      );
  BorderType get _borderType => borderType ?? BorderType.outline;
  Color get _fillColor => readOnly ? AppColor.gray : fillColor ?? AppColor.white;
  BoxBorder? get _border => _borderType.boxBorder(color: borderColor ?? AppColor.gray);
  BorderRadiusGeometry? get _borderRadius => _borderType.boxBorderRadius(radius: borderRadius);

  TextStyle get _hintStyle => hintStyle ?? AppStyle.pickerStyle;
  String get initialHint => hintText ?? "selectFromHere".tr();

  Future<void> showDropDown(BuildContext context) async => await BottomSheetDialog.showCupertinoSheet(
        context,
        child: Stack(
          children: [
            CustomCupertinoPickerWidget(
              children: items.map((dropValue) => dropValue.name).toList(),
              onSelectedItem: (index) => onSelected(items[index]),
            ),
            // Close Icon
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Material(
                color: Colors.transparent,
                child: IconButtonWidget.close(onPressed: context.popDialog),
              ),
            ),
          ],
        ),
      );
}

class _ArrowIconWidget extends StatelessWidget {
  final bool readOnly;
  const _ArrowIconWidget({required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Icon(
        Icons.arrow_back_ios_new,
        size: 14.0,
        color: readOnly ? AppColor.black : AppColor.gray,
      ),
    );
  }
}
