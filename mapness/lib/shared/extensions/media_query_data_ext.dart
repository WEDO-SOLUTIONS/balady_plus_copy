import 'package:flutter/widgets.dart';

extension MediaQueryDataExt on MediaQueryData {
  double get navbarPadding => (48 + viewPadding.bottom) * devicePixelRatio;
  double get quickFilterPadding => 48 * devicePixelRatio;

  // Update when ui-kit bottom sheet is implemented
  double get bottomSheetPadding => .15;

  double get initialMapPadding {
    final navbarSize = navbarPadding;
    final qfilterPadding = quickFilterPadding;
    final deviceHeight = size.height;

    // Update when ui-kit bottom sheet is implemented
    final initBottomSize = bottomSheetPadding;

    // calculate intitial padding for camera
    return (initBottomSize * deviceHeight * devicePixelRatio) + navbarSize + qfilterPadding;
  }
}
