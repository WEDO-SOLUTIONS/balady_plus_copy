import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../shared_feature_exports.dart' show CustomElevatedButtonWidget;

abstract class _ElevatedButton extends StatelessWidget {
  final Widget child;
  const _ElevatedButton(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ElevatedButtonWidget extends _ElevatedButton {
  ///
  ElevatedButtonWidget.login({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnMargin: const EdgeInsets.only(top: 12.0),
          text: "loginButton".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.sendImage({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnMargin: const EdgeInsets.symmetric(horizontal: 34),
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontSize: 12,
          ),
          btnHeight: 40,
          text: "sendImage".tr(),
          onPressed: onPressed,
        ));
}
