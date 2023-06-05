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
}
