import 'package:flutter/material.dart' show EdgeInsets, TextStyle;

import 'utils_exports.dart' show AppColor, AppConfig, AppFontWeight, UIHelper;

class AppStyle {
  static get fontFamily =>
      AppConfig.appFontType.isNotEmpty ? AppConfig.appFontType : null;

  // Text Styles
  static final mainTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
  );
  static final mainTextSecondaryStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
  );
  static final mainTextThirdStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.regular.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
  );
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: UIHelper.mediumPadding,
    vertical: UIHelper.largePadding,
  );
}
