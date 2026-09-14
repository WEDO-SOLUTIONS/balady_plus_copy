import 'package:country_picker/country_picker.dart' show Country, showCountryPicker;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, UIHelper;
import '../../../shared_feature_exports.dart' show CustomElevatedIconButtonWidget, ErrorUnderWidget;

class CustomCountryPickerWidget extends StatelessWidget {
  final Country? initialCountry;

  final double btnWidth;
  final double btnHeight;
  final Color? filledColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  final String? errorMsg;

  final void Function(Country) onSelected;
  const CustomCountryPickerWidget({
    super.key,
    this.initialCountry,
    this.btnWidth = double.infinity,
    this.btnHeight = 55.0,
    this.filledColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.padding,
    this.errorMsg,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Picker
        CustomElevatedIconButtonWidget(
          btnAlignment: MainAxisAlignment.spaceBetween,
          btnPadding: btnPadding,
          btnElevation: 0.0,
          btnWidth: btnWidth,
          btnHeight: btnHeight,
          onPressed: () => onShowPicker(context),
          text: btnText,
          textStyle: btnTextStyle,
          btnColor: btnColor,
          btnBorderColor: btnBorderColor,
          btnBorderWidth: borderWidth,
          btnRadius: borderRadius,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconAlignment: AlignmentDirectional.centerEnd,
        ),
        // Error
        ErrorUnderWidget(errorText: errorMsg),
      ],
    );
  }

  String get btnText => initialCountry?.displayNameNoCountryCode ?? "selectFromHere".tr();
  TextStyle get btnTextStyle => AppStyle.pickerStyle;
  EdgeInsetsGeometry get btnPadding => padding ?? const EdgeInsets.symmetric(horizontal: UIHelper.middlePadding);
  Color get btnColor => filledColor ?? AppColor.gray.withValues(alpha: 0.5);
  Color get btnBorderColor => borderColor ?? AppColor.gray;

  void onShowPicker(BuildContext context) => showCountryPicker(
    context: context,
    // optional. Shows phone code before the country name.
    showPhoneCode: true,
    favorite: <String>['SA'],
    onSelect: (Country country) => onSelected(country),
  );
}
