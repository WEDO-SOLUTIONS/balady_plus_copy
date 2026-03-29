import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class InsetsUtils {
  InsetsUtils._();
  static int? _androidSdkInt;

  static int get androidSdkInt => _androidSdkInt ?? 35;

  static bool get isAndroid15Plus => androidSdkInt >= 35;

  static double stableBottomInset(BuildContext context, {required bool isLandscape}) {
    final p = MediaQuery.viewPaddingOf(context);
    if (!isLandscape || defaultTargetPlatform == TargetPlatform.iOS) {
      return p.bottom;
    }

    return [p.bottom, p.left, p.right].reduce(max);
  }

  static set androidSdkInt(int sdkInt) {
    _androidSdkInt = sdkInt;
  }

  static double platformAwareBottomInset(
    BuildContext context, {
    required bool isLandscape,
  }) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (isAndroid15Plus) {
        return stableBottomInset(context, isLandscape: isLandscape);
      }
      return 0;
    }

    return stableBottomInset(context, isLandscape: isLandscape);
  }
}
