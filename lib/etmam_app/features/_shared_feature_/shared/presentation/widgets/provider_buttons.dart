import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppColorsTheme,
        AppFontWeight,
        ButtonIconPosition,
        IconPath,
        trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomElevatedButtonWidget, CustomSvgIconWidget;
import 'package:flutter/material.dart';

class ProviderButtons extends StatelessWidget {
  final Function onCallPressed;
  final Function onDelegatePress;
  final String? buttonTxt;

  const ProviderButtons(
      {Key? key,
      required this.onCallPressed,
      required this.onDelegatePress,
      this.buttonTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SubmitButton(
            btnTxt: buttonTxt,
            onPressed: onDelegatePress,
          ),
        ),
        const CustomHorizontalSpace(width: 16),
        Expanded(
          child: CallButton(
            onPressed: onCallPressed,
          ),
        )
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  Function onPressed;
  String? btnTxt;

  SubmitButton({Key? key, required this.onPressed, this.btnTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      btnText: btnTxt ?? trans("delegate"),
      btnTextSize: 16,
      btnHeight: 48,
      btnRadius: 2,
      buttonIconPosition: ButtonIconPosition.left,
      btnTextColor: AppColor.white,
      btnTextWeight: AppFontWeight.medium,
      spaceBetweenTextAndIcon: 30,
      btnColor: AppColor.darkTurquoise,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      mainAxisSize: MainAxisSize.max,
      icon: const CustomSvgIconWidget(
        IconPath.delegateIcon,
        iconSize: 24,
      ),
      btnPressed: () => onPressed(),
    );
  }
}

class CallButton extends StatelessWidget {
  Function onPressed;

  CallButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      btnText: trans("call"),
      btnTextSize: 16,
      btnHeight: 48,
      btnRadius: 4,
      buttonIconPosition: ButtonIconPosition.left,
      btnTextColor: AppColor.darkTurquoise,
      btnTextWeight: AppFontWeight.medium,
      spaceBetweenTextAndIcon: 30,
      btnColor: AppColor.white,
      btnBorderColor: AppColor.darkTurquoise,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      mainAxisSize: MainAxisSize.max,
      icon: CustomSvgIconWidget(
        IconPath.callIcon,
        iconSize: 24,
        iconColor: AppColor.darkTurquoise,
      ),
      btnPressed: () => onPressed(),
    );
  }
}
