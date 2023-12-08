import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomInkWellButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath;

class CustomCheckBoxWidget extends StatelessWidget {
  final String checkBoxText;
  final String? checkBoxIcon;
  final String? checkBoxDesc;
  final VoidCallback btnPressed;
  final double textSize;
  final Color unSelectedBackgroundColor;
  bool isSelected;
  final Widget? buttonWidget;

  CustomCheckBoxWidget(
      {Key? key,
      required this.checkBoxText,
      this.checkBoxIcon,
      required this.btnPressed,
      this.textSize = 16,
      this.unSelectedBackgroundColor = AppColor.white,
      this.isSelected = false,
      this.checkBoxDesc,
      this.buttonWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColor.green2 : AppColor.white,
          border: Border.all(
            width: 1,
            color: isSelected ? AppColor.green1 : Colors.transparent,
          )),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInkWellButtonWidget(
                btnPressed: () {
                  btnPressed();
                },
                widget: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: isSelected ? CheckedIcon() : UnCheckedIcon()
                    /*CustomSvgIconWidget(IconPath.checkedIcon,
                          iconColor: AppColorsTheme.primary700, iconSize: 24)*/
                    /* : CustomSvgIconWidget(IconPath.unCheckedIcon,
                          iconColor: AppColorsTheme.primary700, iconSize: 24),*/
                    ),
              ),
              const CustomHorizontalSpace(width: 24),
              Expanded(
                child: Row(
                  //    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (checkBoxIcon != null && checkBoxIcon!.isNotEmpty)
                      CustomSvgIconWidget(checkBoxIcon ?? "", iconSize: 48),
                    const CustomHorizontalSpace(width: 24),
                    Expanded(
                      child: CustomTextWidget(
                        checkBoxText,
                        fontSize: textSize,
                        fontWeight: AppFontWeight.w600,
                        fontColor: AppColor.black,
                        textAlign: TextAlign.start,
                      ),
                      //
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     CustomTextWidget(
                      //       checkBoxText,
                      //       fontSize: textSize,
                      //       fontWeight: AppFontWeight.w600,
                      //       fontColor: AppColor.black,
                      //       textAlign: TextAlign.start,
                      //     ),
                      //     // if (checkBoxDesc != null && checkBoxDesc!.isNotEmpty)
                      //     //   CustomTextWidget(
                      //     //     checkBoxDesc ?? "",
                      //     //     fontSize: 12,
                      //     //     fontWeight: AppFontWeight.regular,
                      //     //     fontColor: AppColor.bottomNavigationShadow,
                      //     //     textAlign: TextAlign.start,
                      //     //   )
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (buttonWidget != null && isSelected) ...[
            const CustomVerticalSpace(height: 32),
            buttonWidget ?? const Center()
          ]
        ],
      ),
    );
  }
}
/*
class CheckedIcon extends StatelessWidget {
  const CheckedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          color: AppColorsTheme.primary700,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Center(
        child: CustomSvgIconWidget(
          IconPath.checkIcon,
          iconSize: 10,
        ),
      ),
    );
  }
}*/

class CheckedIcon extends StatelessWidget {
  const CheckedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          color: AppColor.darkTurquoise,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Center(
        child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(3)))),
      ),
    );
  }
}

class UnCheckedIcon extends StatelessWidget {
  const UnCheckedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.white5),
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
