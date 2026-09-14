import 'package:flutter/material.dart' show Color, EdgeInsets, FontWeight, TextStyle;

import '../utils_exports.dart' show AppColor, AppConfig, AppFontWeight, UIHelper;

class AppStyle {
  static String? get fontFamily => AppConfig.appFontType.isNotEmpty ? AppConfig.appFontType : null;

  /// Text Styles
  static final mainTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.black,
    fontFamily: fontFamily,
  );
  static final athkarTimeStyle = TextStyle(
    fontSize: 16,
    fontFamily: fontFamily,
    color: AppColor.primary800Light,
    fontWeight: AppFontWeight.bold.fontWeight,
  );
  static final timerStyle = TextStyle(
    fontSize: 16,
    color: AppColor.black,
    fontWeight: AppFontWeight.regular.fontWeight,
    fontFamily: fontFamily,
  );
  static final athkarNameStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    color: AppColor.black,
  );
  static final timePickerStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 16,
    fontWeight: AppFontWeight.regular.fontWeight,
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
    fontSize: 16.0,
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
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern800Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final tagStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceTitleStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceDescriptionStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern900Light.withValues(alpha: 0.6),
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final semiBoldTextStyle = TextStyle(
    fontSize: 14.0,
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
    fontSize: 14.0,
    fontWeight: AppFontWeight.light.fontWeight,
    color: AppColor.black54,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceIconTextStyle = TextStyle(
    fontSize: 14.0,
    color: AppColor.blackModern700Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final serviceListTitleTextStyle = TextStyle(
    color: AppColor.blackModern500Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontSize: 16.0,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final appBarTitleTextStyle = TextStyle(
    fontSize: 28.0,
    color: AppColor.blackModern700Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final listTitleTextStyle = TextStyle(
    fontSize: 16.0,
    color: AppColor.blackModern600Light,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final profileSectionTitleTextStyle = TextStyle(
    fontSize: 16.0,
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
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern50Light.withValues(alpha: 0.6),
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final nearbyItemTitleTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final nearbyItemSubTitleTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.black42,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final profileListBetaTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blue600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final cardTitleTextStle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardStatisticsCountTextStle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.black.fontWeight,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardStatisticsTitleTextStle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dashboardNoteTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.secondary900Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final requestNumberTextStle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final requestParamterTitleTextStle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.primary700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );
  static final s14 = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.maastrichtBlue,
    fontFamily: fontFamily,
  );

  static final requestParamterValueTextStle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final subMessageTextStle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final dropDownTitleTextStyle = TextStyle(
    fontSize: 14.0,
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
    fontSize: 16.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.primary700Light,
    fontFamily: fontFamily,
    height: 1.0,
  );

  static final personalInfoParameterValueTextStyle = TextStyle(
    fontSize: 14.0,
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
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
  );

  static final serviceCardWarningTitleTextStyle = TextStyle(
    fontSize: 16.0,
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
  // Athkar Styles
  static final resetAthkarTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
    color: AppColor.grey1000,
  );

  static final countAthkarStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    color: AppColor.blackModern50Light,
  );
  static final boardingTitle = TextStyle(
    color: AppColor.grey1000,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final boardingSubtitle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final boardingButtonStyle = TextStyle(
    color: AppColor.white,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final boardingAppBarTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.white,
  );
  static final desscriptionAthkarStyle = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
    color: AppColor.primary800Light,
  );
  static final countTextAthkarStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  // Violation page styling
  static final violationSelectGuideTitlePageStyle = TextStyle(
    color: AppColor.white,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationSelectGuideSubtitleStyle = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationSelectOptionTitleStyle = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationSelectOptionSubtitleStyle = TextStyle(
    color: AppColor.grayOpacity,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationCreateAppBarTitle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationCreateTitle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violatioCreateSubtitle = TextStyle(
    color: AppColor.blackModern800Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationCreateStyle = TextStyle(
    color: AppColor.blackModern50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationLocationAdressStyle = TextStyle(
    color: AppColor.blackModern800Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationLocationMapStyle = TextStyle(
    color: AppColor.greenLight600,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationLocationDammamMapStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationLocationCategoryMapStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationResultsHeaderStyle = TextStyle(
    color: AppColor.primary50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationStyle = TextStyle(
    color: AppColor.primary50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationNumberStyle = TextStyle(
    color: AppColor.secondary100Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationResultsSectionStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationResultSelectedOptionStyle = TextStyle(
    color: AppColor.primary50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationResultUnSelectedOptionStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationListTitleResultStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationListTitleStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationStartFromStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationNumberStyle1 = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final violationRiyalPerWorkerStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final approvedViolationSectiontitleStyle = TextStyle(
    color: AppColor.blackModern50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final approvedViolationSectionSubtitleStyle = TextStyle(
    color: AppColor.secondary400Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final approvedViolationSelectedNumber = TextStyle(
    color: AppColor.blackModern50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final approvedViolationLabelStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final approvedViolationSubtitle = TextStyle(
    color: AppColor.grey1000,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final createComplianceRiyadhTitle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final createComplianceRiyadhRadioStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceTitleStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceSubtitle = TextStyle(
    color: AppColor.blackModern500Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceFirstSubmitTitleRadioStyle = TextStyle(
    color: AppColor.blackModern800Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceFirstSubmitSubtitleStyle = TextStyle(
    color: AppColor.blackModern500Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceFeesStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceFeesStatusStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceLabelStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceSubtitleStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceDocumentTitleStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final comlianceDocumentMessageStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceClausesTextStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceClausesOptionStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 14,
    fontWeight: AppFontWeight.medium.fontWeight,
    fontFamily: fontFamily,
  );
  static final comlianceImageUploadStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceTitleLabelLicenseStyle = TextStyle(
    color: AppColor.blueSkyLight800,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final complianceSubtitleLicenseStyle = TextStyle(
    color: AppColor.blackModern600Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  // Events Styles
  static final eventsMainPageStyle = TextStyle(
    color: AppColor.blackModern700Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsOptionsStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsMonthStyle = TextStyle(
    color: AppColor.blackOpacity,
    fontSize: 14,
    fontWeight: AppFontWeight.regular.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsMonthStyle1 = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: AppFontWeight.regular.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsDayStyle = TextStyle(
    color: AppColor.black,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsDayStyle1 = TextStyle(
    color: AppColor.white,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsSectionTitleStyle = TextStyle(
    color: AppColor.blackModern50Light,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsLocationTextStyle = TextStyle(
    color: AppColor.blackModern300Light,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final moneyStyleEvents = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final riyalEventStyle = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventMainTitleStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsMainSubtitleStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsTitleSectionStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsDetailsTitleStyle = TextStyle(
    color: AppColor.blackModern600Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsDetailsSubtitleStyle = TextStyle(
    color: AppColor.blackModern500Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsDescriptionTextStyle = TextStyle(
    color: AppColor.blackModern500Light,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsCategory = TextStyle(
    color: AppColor.greenOpacity,
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventNotFoundTextStyle = TextStyle(
    color: AppColor.grey1000,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final selfRatingTitleStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final selfRatingSubtitleStyle = TextStyle(
    color: AppColor.blackModern800Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final selfRatingSectionTextStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );

  static final dateTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
  );

  static final tagTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final chatMessageTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern50Light,
    fontFamily: fontFamily,
  );

  static final locationCardTitleTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final locationCardAddressTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
  );

  static final textFieldSuffixTextStyle = TextStyle(
    color: Color(0x7F1A1A1A),
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
  );

  static final compassOffsetTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.riverBed,
    fontFamily: fontFamily,
  );

  static final compassDirectionTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeight.medium.fontWeight,
    color: AppColor.riverBed,
    fontFamily: fontFamily,
  );

  static final costTitleTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern600Light,
    fontFamily: fontFamily,
  );

  static final costTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final textFieldTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.bold.fontWeight,
    color: AppColor.blackModern700Light,
    fontFamily: fontFamily,
  );

  static final lightTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.primary900Light,
    fontFamily: fontFamily,
  );

  static final lightTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.fontWeight,
    color: AppColor.blackModern500Light,
    fontFamily: fontFamily,
    height: 1.5,
  );

  static final resultsLastDescription = TextStyle(
    color: AppColor.secondary400Light,
    fontSize: 14,
    fontWeight: AppFontWeight.medium.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsStateMonthStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );
  static final eventsStateDayStyle = TextStyle(
    color: AppColor.blackModern900Light,
    fontSize: 14,
    fontWeight: AppFontWeight.bold.fontWeight,
    fontFamily: fontFamily,
  );

  /// Padding
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: UIHelper.mediumPadding,
    vertical: UIHelper.largePadding,
  );
}
