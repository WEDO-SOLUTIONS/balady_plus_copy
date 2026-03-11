import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class InsetsUtils {
  InsetsUtils._();
  static int? _androidSdkInt;

  static int get androidSdkInt => _androidSdkInt ?? 35;

  static EdgeInsets _rawViewPadding(BuildContext context) {
    final view = View.of(context);
    final dpr = view.devicePixelRatio;
    final p = view.viewPadding;
    return EdgeInsets.fromLTRB(
      p.left / dpr,
      p.top / dpr,
      p.right / dpr,
      p.bottom / dpr,
    );
  }

  static double _stableBottomInset(BuildContext context, {required bool isLandscape}) {
    final p = _rawViewPadding(context);
    if (!isLandscape) {
      return p.bottom;
    }

    return [p.bottom, p.left, p.right].reduce(max);
  }

  static bool _isAndroid15Plus() {
    final isAndroid15Plus = androidSdkInt >= 35;
    logger.log('Android API: $androidSdkInt, isAndroid15Plus: $isAndroid15Plus');
    return isAndroid15Plus;
  }

  static set androidSdkInt(int sdkInt) {
    _androidSdkInt = sdkInt;
  }

  static double platformAwareBottomInset(
    BuildContext context, {
    required bool isLandscape,
  }) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _stableBottomInset(context, isLandscape: false);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // if (_isAndroid15Plus()) {
      //   return _stableBottomInset(context, isLandscape: isLandscape);
      // }
      return _stableBottomInset(context, isLandscape: isLandscape);
    }

    return 0;
  }
}
