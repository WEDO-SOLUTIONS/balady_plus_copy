import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, UIHelper;
import '../../shared_feature_exports.dart'
    show CustomTextWidget, ErrorUnderWidget;

class CustomRadioButtonWidget extends StatelessWidget {
  final double btnHeight;
  final double btnWidth;
  final Color btnBorderUnSelectedColor;
  final Color btnBorderSelectedColor;
  final double btnBorderRadius;
  final Color btnBackgroundUnSelectedColor;
  final Color btnBackgroundSelectedColor;
  final EdgeInsetsGeometry? btnPadding;
  final EdgeInsetsGeometry? btnMargin;

  final double radioHeight;
  final double radioWidth;
  final Color radioSelectedColor;
  final Color radioUnSelectedColor;
  final Color radioSelectedBorderColor;
  final Color radioUnSelectedBorderColor;
  final dynamic radioValue;
  final dynamic radioGroupValue;

  final double radioLabelSpace;

  final String label;
  final TextStyle? labelStyle;

  final String? errorMsg;

  final bool isSelected;
  final Function(dynamic) onSelected;

  const CustomRadioButtonWidget({
    Key? key,
    this.btnHeight = 60.0,
    this.btnWidth = double.infinity,
    this.btnBorderUnSelectedColor = AppColor.gray,
    this.btnBorderSelectedColor = AppColor.blue,
    this.btnBorderRadius = 4.0,
    this.btnBackgroundUnSelectedColor = Colors.transparent,
    this.btnBackgroundSelectedColor = Colors.transparent,
    this.btnPadding,
    this.btnMargin,
    this.radioHeight = 25.0,
    this.radioWidth = 25.0,
    this.radioSelectedColor = AppColor.blue,
    this.radioUnSelectedColor = AppColor.white,
    this.radioSelectedBorderColor = Colors.transparent,
    this.radioUnSelectedBorderColor = AppColor.gray,
    required this.radioValue,
    required this.radioGroupValue,
    this.radioLabelSpace = 12.0,
    required this.label,
    this.labelStyle,
    this.errorMsg,
    this.isSelected = false,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: btnHeight,
          width: btnWidth,
          alignment: AlignmentDirectional.centerStart,
          margin: getBtnMargin,
          decoration: BoxDecoration(
            border: Border.all(color: btnBorderColor),
            borderRadius: BorderRadius.circular(btnBorderRadius),
          ),
          child: InkWell(
            splashColor: btnBorderSelectedColor,
            highlightColor: Theme.of(context).scaffoldBackgroundColor,
            onTap: () => onSelected(radioValue),
            child: ListTile(
              // dense: true,
              // onTap: () => onSelected(radioValue),
              selected: isRadioSelected,
              tileColor: btnBackgroundUnSelectedColor,
              selectedTileColor: btnBackgroundSelectedColor,
              horizontalTitleGap: radioLabelSpace,
              minLeadingWidth: 0.0,
              minVerticalPadding: 0.0,
              contentPadding: btnPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: UIHelper.smallPadding,
                    vertical: 0.0,
                  ),
              leading: _RadioWidget(
                width: radioWidth,
                height: radioHeight,
                color: radioColor,
                borderColor: radioBorderColor,
              ),
              title: CustomTextWidget(
                label,
                textStyle: labelStyle ??
                    AppStyle.mainTextSecondaryStyle.copyWith(
                      fontSize: 14.0,
                      height: 1.0,
                    ),
              ),
            ),
          ),
        ),
        // Error
        ErrorUnderWidget(errorText: errorMsg),
      ],
    );
  }

  EdgeInsetsGeometry get getBtnMargin =>
      btnMargin ??
      EdgeInsets.only(bottom: showError ? 2.0 : UIHelper.middlePadding);

  Color get btnBorderColor =>
      isRadioSelected ? btnBorderSelectedColor : btnBorderUnSelectedColor;
  Color get radioColor =>
      isRadioSelected ? radioSelectedColor : radioUnSelectedColor;
  Color get radioBorderColor =>
      isRadioSelected ? radioSelectedBorderColor : radioUnSelectedBorderColor;

  bool get isRadioSelected => isSelected || radioGroupValue == radioValue;

  bool get showError => errorMsg != null && errorMsg!.isNotEmpty;
}

class _RadioWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color borderColor;

  const _RadioWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Container(
        width: width / 3.25,
        height: height / 3.25,
        decoration: const BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
