import 'package:flutter/material.dart' show EdgeInsets, TextStyle;

import '../utils_exports.dart'
    show AppColor, AppConfig, AppFontWeight, UIHelper;

class AppStyle {
  static get fontFamily =>
      AppConfig.appFontType.isNotEmpty ? AppConfig.appFontType : null;

  /// Text Styles
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
  static final textButtonStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final elevatedButtonStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.white,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final radioButtonStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final checkBoxStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final pickerStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final sectionTitleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final tagStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceTitleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceDescriptionStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern900Light.withOpacity(0.6),
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final semiBoldTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final blackTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.black.fontWeight,
    color: AppColor.blackModern900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final prayerTimeStyle = TextStyle(
    fontSize: 8.0,
    fontWeight: AppFontWeight.light.fontWeight,
    color: AppColor.black54,
    fontFamily: fontFamily,
    height: 1.0,
  );

  /// Padding
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: UIHelper.mediumPadding,
    vertical: UIHelper.largePadding,
  );
}
