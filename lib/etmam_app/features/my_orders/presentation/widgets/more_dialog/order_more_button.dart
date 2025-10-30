import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, ButtonIconPosition;
import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextButtonWithIconWidget, DrawLineWidget;

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
        CustomTextButtonWithIconWidget(
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
          icon: CustomSvgIconWidget(
            icon,
            iconSize: 24,
          ),
          btnPressed: btnPressed,
        ),
        DrawLineWidget(
          lineColor: Color(0xff979797).withOpacity(0.09530785112257859),
        ),
      ],
    );
  }
}
