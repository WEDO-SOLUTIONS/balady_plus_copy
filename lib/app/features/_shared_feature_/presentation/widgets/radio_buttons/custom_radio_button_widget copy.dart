import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions;
import '../../../shared_feature_exports.dart'
    show CustomVerticalSpace, CustomTextWidget;

class CustomRadioButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color borderColor;
  final Color borderSelectedColor;
  final double borderRadius;
  final Function(dynamic) onSelected;
  final bool isSelected;
  final Color backgroundColor;
  final Color backgroundSelectedColor;
  final double space;
  final EdgeInsetsGeometry? padding;
  final double horizontalPadding;
  final double verticalPadding;
  final double radioHeight;
  final double radioWidth;
  final Color radioSelectedColor;
  final Color radioUnSelectedColor;
  final dynamic radioValue;
  final dynamic radioGroupValue;
  final String title;
  final Color titleColor;
  final double titleSize;
  final AppFontWeight titleFontWeight;

  final String? errorMsg;

  const CustomRadioButtonWidget({
    super.key,
    this.height = 60.0,
    this.width = double.infinity,
    this.borderColor = AppColor.black200,
    this.borderSelectedColor = AppColor.primary900Light,
    this.borderRadius = 4.0,
    required this.onSelected,
    this.isSelected = false,
    this.backgroundColor = Colors.transparent,
    this.backgroundSelectedColor = AppColor.duckEggBlue,
    this.space = 12.0,
    this.padding,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 0.0,
    this.radioHeight = 25.0,
    this.radioWidth = 25.0,
    this.radioSelectedColor = AppColor.primary900Light,
    this.radioUnSelectedColor = AppColor.white,
    required this.radioValue,
    required this.radioGroupValue,
    required this.title,
    this.titleColor = AppColor.black,
    this.titleSize = 18.0,
    this.titleFontWeight = AppFontWeight.medium,
    this.errorMsg,
  });

  final Color _unselectedBorderColor = AppColor.white5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          alignment: AlignmentDirectional.centerStart,
          margin: const EdgeInsets.only(bottom: GeneralKey.semiMediumPadding),
          decoration: BoxDecoration(
            border: Border.all(
              color: (isSelected || radioGroupValue == radioValue)
                  ? borderSelectedColor
                  : borderColor,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ListTile(
            // dense: true,
            onTap: () => onSelected(radioValue),
            selected: (isSelected || radioGroupValue == radioValue),
            tileColor: backgroundColor,
            selectedTileColor: backgroundSelectedColor,
            horizontalTitleGap: space,
            minLeadingWidth: 0.0,
            minVerticalPadding: 0.0,
            contentPadding: padding ??
                EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
            leading: _RadioWidget(
              width: radioWidth,
              height: radioHeight,
              color: (isSelected || radioGroupValue == radioValue)
                  ? radioSelectedColor
                  : radioUnSelectedColor,
              borderColor: (isSelected || radioGroupValue == radioValue)
                  ? radioSelectedColor
                  : _unselectedBorderColor,
            ),
            title: Container(
              // color: Colors.blue,
              height: radioHeight,
              alignment: CommonFunctions.isAppAR
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: CustomTextWidget(
                title,
                fontWeight: titleFontWeight,
                fontColor: titleColor,
                textAlign: TextAlign.start,
                fontSize: titleSize,
              ),
            ),
          ),
        ),
        if (errorMsg != null && errorMsg!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(height: 8.0),
              CustomTextWidget(
                errorMsg!,
                fontSize: 13.0,
                fontColor: AppColor.error,
                fontWeight: AppFontWeight.medium,
              ),
            ],
          ),
      ],
    );
  }
}

class _RadioWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color borderColor;

  const _RadioWidget({
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
  });

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
        width: width / 3.0,
        height: height / 3.0,
        decoration: const BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class CustomRadioButtonEnd<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? currentSelected;
  final Function onChange;
  final bool endRadio;
  final double textSize;
  final Color unSelectedBackgroundColor;
  final String? subTitle;
  final double? height;
  final bool? isDisabled;

  const CustomRadioButtonEnd(
      {super.key,
      required this.title,
      required this.value,
      required this.currentSelected,
      required this.onChange,
      this.height,
      this.endRadio = true,
      this.textSize = 14,
      this.unSelectedBackgroundColor = AppColor.white,
      this.subTitle,
      this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (isDisabled != true) ? onChange(value) : () {},
      child: Container(
        height: height ?? 72,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsetsDirectional.only(
          start: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          /* color: currentSelected == value
                ? AppColor.duckEggBlue
                : unSelectedBackgroundColor,*/

          color: Color(0x80E6EFEF),
          /* border: Border.all(
              width: 1,
              color: currentSelected == value
                  ? AppColor.primary900Light
                  : AppColor.black200,
            )*/
        ),
        child: Center(
          child: Row(
            children: [
              if (!endRadio)
                Radio<T>(
                  value: value,
                  groupValue: currentSelected,
                  activeColor: AppColor.primary900Light,
                  onChanged: (v) {
                    if (isDisabled != true) onChange(v);
                  },
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      title,
                      fontSize: textSize,
                      fontWeight: AppFontWeight.medium,
                      fontColor: isDisabled == true
                          ? AppColor.warmGrey2
                          : AppColor.black,
                      maxLines: 4,
                      textAlign: TextAlign.start,
                    ),
                    if (subTitle != null) ...[
                      CustomVerticalSpace(height: 8),
                      CustomTextWidget(
                        subTitle ?? "",
                        fontSize: textSize,
                        fontWeight: AppFontWeight.medium,
                        fontColor: AppColor.black,
                        maxLines: 4,
                        textAlign: TextAlign.start,
                      ),
                    ]
                  ],
                ),
              ),
              if (endRadio)
                Radio<T>(
                  value: value,
                  groupValue: currentSelected,
                  activeColor: AppColor.primary900Light,
                  onChanged: (v) {
                    if (isDisabled != true) onChange(v);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRadioButtonWithoutDecoration extends StatelessWidget {
  final String title;
  final String value;
  final String currentSelected;
  final Function onChange;

  const CustomRadioButtonWithoutDecoration(
      {super.key,
      required this.title,
      required this.value,
      required this.currentSelected,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChange(value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: currentSelected,
            activeColor: AppColor.primary900Light,
            onChanged: (v) {
              onChange(v);
            },
          ),
          Expanded(
            child: CustomTextWidget(
              title,
              fontSize: 16,
              fontWeight: AppFontWeight.medium,
              fontColor: AppColor.black,
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
