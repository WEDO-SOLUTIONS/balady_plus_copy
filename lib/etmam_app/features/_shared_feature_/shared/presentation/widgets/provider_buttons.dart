import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColorsTheme, AppFontWeight, ButtonIconPosition, IconPath, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomElevatedButtonWidget, CustomSvgIconWidget;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';

class ProviderButtons extends StatelessWidget {
  final Function onCallPressed;
  final Function? onDelegatePress;
  final String? buttonTxt;
  final double? btnSize;

  const ProviderButtons({
    Key? key,
    required this.onCallPressed,
    this.onDelegatePress,
    this.btnSize,
    this.buttonTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (onDelegatePress != null) ...[
          Expanded(
            child: SubmitButton(
              btnTxt: buttonTxt,
              btnSize: btnSize,
              onPressed: onDelegatePress!,
            ),
          ),
          const CustomHorizontalSpace(width: 16),
        ],
        Expanded(
          child: CallButton(
            onPressed: onCallPressed,
            btnSize: btnSize,
          ),
        )
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  Function onPressed;
  String? btnTxt;
  double? btnSize;

  SubmitButton({Key? key, required this.onPressed, this.btnTxt, this.btnSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String delegate = sl<EtmamEntryPointCubit>().isLifeStyle
        ? "request_city_service".tr()
        : "delegate".tr();
    return CustomElevatedButtonWidget(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      btnText: btnTxt ?? delegate,
      btnTextSize: 14,
      btnHeight: btnSize ?? 56,
      btnRadius: 6,
      btnTextColor: AppColor.white,
      btnTextWeight: AppFontWeight.bold,
      btnColor: AppColor.primary900Light,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      btnPressed: () => onPressed(),
    );
  }
}

class CallButton extends StatelessWidget {
  Function onPressed;
  double? btnSize;

  CallButton({Key? key, required this.onPressed, this.btnSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      btnText: trans("call"),
      btnTextSize: 14,
      btnHeight: btnSize ?? 56,
      btnRadius: 6,
      btnBorderWidth: 1,
      btnTextColor: AppColor.primary900Light,
      btnTextWeight: AppFontWeight.bold,
      btnColor: AppColor.white,
      btnBorderColor: AppColor.primary900Light,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      btnPressed: () => onPressed(),
    );
  }
}
