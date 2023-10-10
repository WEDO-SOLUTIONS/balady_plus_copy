import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show DrawLineWidget;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, ButtonIconPosition;
import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextButtonWithIconWidget;

/*class OrderMoreButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? btnPressed;
  final Color btnColor;

  const OrderMoreButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.btnPressed,
      this.btnColor = AppColor.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextButtonWithIconWidget(
      mainAxisAlignment: MainAxisAlignment.start,
      btnText: text,
      btnTextSize: 16,
      btnTextColor: btnColor,
      btnTextWeight: AppFontWeight.medium,
      textOverflow: TextOverflow.ellipsis,
      maxLines: 1,
      withFlexible: true,
      buttonIconPosition: ButtonIconPosition.right,
      spaceBetweenTextAndIcon: 16,
      padding: const EdgeInsets.all(25),
      icon: CustomSvgIconWidget(
        icon,
        iconSize: 20,
        iconColor: btnColor,
      ),
      btnPressed: btnPressed,
    );
  }
}*/

class OrderMoreButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? btnPressed;
  final Color btnColor;

  const OrderMoreButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.btnPressed,
      this.btnColor = AppColor.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColor.white3.withOpacity(0.3)
          ),
          child: CustomTextButtonWithIconWidget(
            mainAxisAlignment: MainAxisAlignment.start,
            btnText: text,
            btnTextSize: 17,
            btnTextColor: AppColor.black,
            btnTextWeight: AppFontWeight.medium,
            textOverflow: TextOverflow.ellipsis,
            maxLines: 1,
            withFlexible: true,
            buttonIconPosition: ButtonIconPosition.right,
            spaceBetweenTextAndIcon: 16,
            padding: const EdgeInsets.symmetric(vertical: 25),
            icon: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: AppColor.primary900,
              ),
              child: CustomSvgIconWidget(
                icon,
                iconSize: 14,
                iconColor: AppColor.white,
              ),
            ),
            btnPressed: btnPressed,
          ),
        ),
        DrawLineWidget(
          lineColor: Color(0xff979797).withOpacity(0.09530785112257859),
        ),
      ],
    );
  }
}
