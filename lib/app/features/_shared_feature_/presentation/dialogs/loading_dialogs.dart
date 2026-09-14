import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart' show LoadingAnimationWidget;

import '../../../../core/utils/utils_exports.dart' show AppColor;

class LoadingDialog {
  static Future<bool> showAnimatedLoading(BuildContext context, {Color loadingColor = AppColor.blue}) async =>
      await _showDialog(
        context,
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: LoadingAnimationWidget.fourRotatingDots(color: loadingColor, size: 40),
        ),
      );

  static Future<bool> showDefaultLoading(BuildContext context, {Color loadingColor = AppColor.blue}) async =>
      await _showDialog(
        context,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(loadingColor)),
        ),
      );

  static Future<bool> _showDialog(BuildContext context, {required Widget child}) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(opacity: a1.value, child: child),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        // barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;
}
