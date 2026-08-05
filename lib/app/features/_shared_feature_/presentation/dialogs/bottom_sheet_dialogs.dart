import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

import '../../../../core/utils/utils_exports.dart' show ContextConversion;

class BottomSheetDialog {
  static Future<T> showDraggableSheet<T>(
    BuildContext context, {
    required Widget child,
    Color? backgroundColor,
    Color? barrierColor,
    double borderRadius = 28.0,
    bool isDismissible = true,
    bool isFullHeight = true,
    double? height,
    bool isScrollControlled = true,
    bool enableDrag = true,
    String? currentRouteName,
    String? dialogKeyName,
  }) async {
    final screenHeight = context.screenHeight;
    final screenStatusBarHeight = context.topPadding + 20.0;

    if (dialogKeyName != null) BaladyAnalytics.instance.screen(dialogKeyName);

    dynamic value =
        (await showModalBottomSheet(
          context: context,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          enableDrag: enableDrag,
          backgroundColor: Colors.transparent,
          barrierColor: barrierColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius))),
          builder: (context) => Padding(
            padding: EdgeInsets.only(top: screenStatusBarHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
              child: SizedBox(
                // height: height ?? screenHeight * 0.90, // 90% from screenHeight
                height: isFullHeight ? screenHeight - screenStatusBarHeight : height,
                child: child,
              ),
            ),
          ),
        )) ??
        false;

    if (currentRouteName != null) BaladyAnalytics.instance.screen(currentRouteName);

    return value;
  }

  static Future<bool> showRequestService(BuildContext context, {required Widget child}) =>
      showSheet(context, child: child, isDismissible: true, isScrollControlled: false);

  static Future<bool> showCloseRequest(BuildContext context, {required Widget child}) =>
      showSheet(context, child: child, isScrollControlled: false);

  static Future<T> showSheet<T>(
    BuildContext context, {
    required Widget child,
    Color? backgroundColor,
    Color? barrierColor,
    double borderRadius = 28.0,
    bool isFullHeight = false,
    double? height,
    bool isDismissible = false,
    bool isScrollControlled = true,
    bool enableDrag = false,
  }) async {
    final screenHeight = context.screenHeight;
    final screenStatusBarHeight = context.topPadding + 10.0;
    return (await showModalBottomSheet(
          context: context,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          enableDrag: enableDrag,
          // useRootNavigator: false,
          backgroundColor: backgroundColor,
          barrierColor: barrierColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius))),
          builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              // height: height ?? screenHeight * 0.90, // 90% from screenHeight
              height: isFullHeight ? screenHeight - screenStatusBarHeight : height,
              child: child,
            ),
          ),
        )) ??
        false;
  }

  static Future<T> showCupertinoSheet<T>(BuildContext context, {required Widget child, double height = 220.0}) async =>
      (await showCupertinoModalPopup(
        context: context,
        barrierDismissible: true,
        builder: (_) => SizedBox(height: height, child: child),
      )) ??
      false;
}
