import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../shared_feature_exports.dart'
    show CustomElevatedIconButtonWidget, CustomSvgIconWidget;

abstract class _ElevatedIconButton extends StatelessWidget {
  final Widget child;
  const _ElevatedIconButton(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ElevatedIconButtonWidget extends _ElevatedIconButton {
  ///
  ElevatedIconButtonWidget.upload({required VoidCallback onPressed})
      : super(CustomElevatedIconButtonWidget(
          text: "uploadButton".tr(),
          textStyle: AppStyle.elevatedButtonStyle,
          btnColor: AppColor.blue,
          btnBorderColor: Colors.transparent,
          icon: const CustomSvgIconWidget(IconPath.upload, iconSize: 12.0),
          onPressed: onPressed,
        ));
}
