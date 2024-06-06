import 'dart:io';

import 'package:flutter/widgets.dart';

extension MediaQueryDataExt on MediaQueryData {
  double get navbarPadding => 48 + viewPadding.bottom;
  double get quickFilterPadding => 48 * devicePixelRatio;
  double get bottomSheetPadding => Platform.isIOS ? .3 : .38;

  double get initialMapPadding {
    final navbarSize = navbarPadding;
    final qfilterPadding = quickFilterPadding;
    final deviceHeight = size.height;

    // Update when ui-kit bottom sheet is implemented
    final initBottomSize = bottomSheetPadding;

    // calculate intitial padding for camera
    return (initBottomSize * deviceHeight * devicePixelRatio) + (navbarSize * devicePixelRatio) + qfilterPadding;
  }
}
