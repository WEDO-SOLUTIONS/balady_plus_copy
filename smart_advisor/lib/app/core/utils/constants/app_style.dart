import 'dart:ui';

import 'package:flutter/material.dart' show EdgeInsets, TextStyle;

import '../utils_exports.dart' show AppColor, AppConfig, UIHelper;

class AppStyle {
  static get fontFamily =>
      AppConfig.appFontType.isNotEmpty ? AppConfig.appFontType : null;

  /// Text Styles
  static final mainTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final accentBoldStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final heading1BoldStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
  //new
  static final headingBoldStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final heading2BoldStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final calloutBoldStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final textRegularRomanStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final footNoteRomanStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final footNoteMediumStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
  static final footNoteBoldStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final captionRomanStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final textRegularStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
//textRegularRomanStyle
  static final textlargeRegularStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
//new
  static final textMediumStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
  static final somarSemiBold = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );

  static final callout1BoldStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimaryColor,
    fontFamily: fontFamily,
  );
}
