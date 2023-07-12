import 'package:flutter/material.dart'
    show Color, EdgeInsets, FontWeight, TextStyle;

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

  static final serviceIconTextStyle = TextStyle(
    fontSize: 9.0,
    color: AppColor.blackModern700Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceListTitleTextStyle = TextStyle(
    color: AppColor.blackModern500Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontSize: 15.0,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final appBarTitleTextStyle = TextStyle(
    fontSize: 20.0,
    color: AppColor.blackModern700Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final listTitleTextStyle = TextStyle(
    fontSize: 14.0,
    color: AppColor.blackModern600Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final profileSectionTitleTextStyle = TextStyle(
    fontSize: 18.0,
    color: AppColor.blackModern500Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final profileNameTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.black.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
    // height: 1.0,
  );

  static final profileTypeTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern50Light.withOpacity(0.6),
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final nearbyItemTitleTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final nearbyItemSubTitleTextStyle = TextStyle(
    fontSize: 9.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.black42,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final profileListBetaTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blue600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final cardTitleTextStle = TextStyle(
    fontSize: 18.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardStatisticsCountTextStle = TextStyle(
    fontSize: 18.0,
    fontWeight: AppFontWeight.black.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardStatisticsTitleTextStle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardNoteTextStle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.secondary900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final requestNumberTextStle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final requestParamterTitleTextStle = TextStyle(
    fontSize: 10.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.primary700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final subMessageTextStle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dropDownTitleTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dropDownValueTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final personalInfoParameterTitleTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.primary700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final personalInfoParameterValueTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final signInFullTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.doveGray,
    fontFamily: fontFamily,
  );

  static final serviceCardDescriptionTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
  );

  static final serviceCardParameterTitleTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
  );

  static final serviceCardWarningTitleTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final prayerTimeCityTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.secondary200Light,
    fontFamily: fontFamily,
  );

  static final prayerTimeDateTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
  );

  static final dateTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
  );

  static final tagTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final chatMessageTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
  );

  static final locationCardTitleTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.darkTurquoise,
    fontFamily: fontFamily,
  );

  static final locationCardAddressTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
  );

  static const textFieldSuffixTextStyle = TextStyle(
    color: Color(0x7F1A1A1A),
    fontSize: 12,
    fontFamily: 'Arabic UI Display',
    fontWeight: FontWeight.w600,
  );

  /// Padding
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: UIHelper.mediumPadding,
    vertical: UIHelper.largePadding,
  );
}
