import 'package:flutter/material.dart';

class Constants {
  /// app config
  static const String appFontType = 'packages/balady_design_system/IBMPlexSansArabic';
  static const String cairoFontType = 'Cairo';
  static const String geezaProFontType = 'GeezaPro';
  static const String lucidaGrandFontType = 'LucidaGrande';

  static const String appLanguagesPath = 'assets/lang/';
  static const int numOfPins = 4;

  // vertical space
  static const SizedBox verticalSpaceSmall = SizedBox(height: 12.0);
  static const SizedBox verticalSpaceMedium = SizedBox(height: 24.0);
  static const SizedBox verticalSpaceLarge = SizedBox(height: 60.0);

  // horizontal space
  static const SizedBox horizontalSpaceSmall = SizedBox(width: 12.0);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: 24.0);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: 60.0);

  // Default padding
  static const double semiSmallPadding = 8.0;
  static const double smallPadding = 12.0;
  static const double semiMediumPadding = 18.0;
  static const double mediumPadding = 24.0;
  static const double semiLargePadding = 32.0;
  static const double largePadding = 60.0;

  // Switcher size
  // static const double androidSwitchHeight = 32.0;
  // static const double androidSwitchWidth = 47.0;
  static const double switchHeight = 30.0;
  static const double switchWidth = 50.0;

  //  Box Decoration with shadow and round corner for cards
  static const BoxDecoration boxDecorationWithShadowAndRoundedCorner = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    boxShadow: boxShadow,
    color: Colors.white,
  );

  // box shadow for cards
  static const List<BoxShadow> boxShadow = [
    BoxShadow(color: Color(0x1a000000), offset: Offset(0, 2), blurRadius: 10, spreadRadius: 0),
  ];

  // box shadow for appBar
  static const List<BoxShadow> appBarBoxShadow = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 2), blurRadius: 15, spreadRadius: 0),
  ];

  /// keys
  // shared preferences keys
  static const String securityInfoKey = 'security-info';

  // appbar keys
  static const String appBarAnimationKey = 'app-bar-animation';
  static const String cardPositionAnimationKey = 'card-position-animation';
  static const String cardScaleAnimationKey = 'card-scale-animation';
  static const String cardOpacityAnimationKey = 'card-opacity-animation';
  static const String headerBodyTweenSpaceAnimationKey = 'header-body-tween-space-animation';
  static const String cardHeightKey = 'card-height';
  static const String extraHeaderSpaceKey = 'extra-header-space';
  static const String extraBodyHeightKey = 'extra-body-height';

  // Navigation bar keys
  static const String bottomNavigationBarHomeKey = 'home';
  static const String bottomNavigationBarServicesDirectoryKey = 'services-directory';
  static const String bottomNavigationBarDigitalWalletKey = 'digital-wallet';
  static const String bottomNavigationBarStoreKey = 'etmam_store';
  static const String bottomNavigationBarMoreKey = 'more';

  // Home apps keys
  static const String homeAppsLicenseManagementKey = 'license-management';
  static const String homeAppsFeeCalculatorKey = 'fee-calculator';
  static const String homeAppsCustomerVoiceKey = 'customer-voice';
  static const String homeAppsEnquiriesKey = 'enquiries';
  static const String homeAppsVisitKey = 'visit';
  static const String homeAppsOpportunitiesKey = 'opportunities';
  static const String homeAppsYourOpinionKey = 'your-opinion';
  static const String homeAppsAppointmentsKey = 'appointments';
  static const String homeAppsApp7Key = 'app7';
  static const String homeAppsAppSlaughterKey = 'slaughter';
  static const String homeAppsEkramKey = 'ekram';

  // Home latest updates type keys
  static const String homeLatestUpdatesLicenseManagementKey = 'license-management';
  static const String homeLatestUpdatesCustomerVoiceKey = 'customer-voice';

  // license services keys
  static const String licenseServicesNewLicenseKey = 'license-services-new-license';
  static const String licenseServicesCancelLicenseKey = 'license-services-cancel-license';
  static const String licenseServicesEditLicenseKey = 'license-services-edit-license';
  static const String licenseServicesRenewLicenseKey = 'license-services-renew-license';
  static const String licenseServicesTransferOwnershipLicenseKey = 'license-services-transfer-ownership-license';

  // service directory keys
  // tabs
  static const String servicesDirectoryTabAllKey = 'services-directory-tab-all';
  static const String servicesDirectoryTabCommercialServicesKey = 'services-directory-tab-commercial-services';
  static const String servicesDirectoryTabDevelopmentAndConstructionKey =
      'services-directory-tab-development-and-construction';
  static const String servicesDirectoryTabLandAndSpaceServicesKey = 'services-directory-tab-land-and-space-services';

  // types
  static const String servicesDirectoryLicenseServiceTypeCommercialServicesKey =
      'services-directory-license-service-type-commercial-services';
  static const String servicesDirectoryLicenseServiceTypeDevelopmentAndConstructionKey =
      'services-directory-license-service-type-development-and-construction';
  static const String servicesDirectoryLicenseServiceTypeLandAndSpaceServicesKey =
      'services-directory-license-service-type-land-and-space-services';

  // services
  static const String servicesDirectoryCommercialLicensesKey = 'services-directory-commercial-licenses';
  static const String servicesDirectoryConstructionLicensesKey = 'services-directory-construction-licenses';
  static const String servicesDirectoryArealResolutionKey = 'services-directory-areal-resolution';
  static const String servicesDirectoryOperatingLicensesKey = 'services-directory-operating-licenses';
  static const String servicesDirectoryGrantServicesKey = 'services-directory-grant-services';
  static const String servicesDirectoryLandAndPropertyKey = 'services-directory-land-and-property';
  static const String servicesDirectoryMunicipalOversightKey = 'services-directory-municipal-oversight';
  static const String servicesDirectoryShelterFacilitiesKey = 'services-directory-shelter-facilities';
  static const String servicesDirectoryOpticalDistortionKey = 'services-directory-optical-distortion';
  static const String servicesDirectoryFossilsServicesKey = 'services-directory-fossils-services';

  // more keys
  static const String moreDashboardKey = 'more-dashboard';
  static const String morePersonalInfoKey = 'more-personal-info';
  static const String moreBuildingsKey = 'more-buildings';
  static const String moreSettingsKey = 'more-settings';
  static const String moreHelpKey = 'more-help';
  static const String moreAppRatingKey = 'more-app-rating';
  static const String moreAboutBaladyKey = 'more-about-balady';
  static const String moreLogoutKey = 'more-logout';
  static const String moreContactInfoKey = 'more-contact-info';
  static const String moreContactUsKey = 'more-contact-us';
  static const String moreBaladyWebSiteKey = 'more-balady-web-site';
  static const String moreBaladyTwitterKey = 'more-balady-twitter';
  static const String moreBaladyPhoneKey = 'more-balady-phone';
  static const String moreBaladyEmailKey = 'more-balady-email';
  static const String morePrivacyKey = 'more-privacy';
  static const String morePrivacyChangePinKey = 'more-privacy-change-pin';

  // types
  static const String moreSectionAccountKey = 'more-section-account';
  static const String moreSectionSupportKey = 'more-section-support';
  static const String moreSectionGeneralKey = 'more-section-general';

  // dashboard keys
  static const String dashboardCommercialLicenseKey = 'dashboard-commercial-license';
  static const String dashboardConstructionLicenseKey = 'dashboard-construction-license';
  static const String dashboardArealResolutionKey = 'dashboard-areal-resolution';
  static const String dashboardWorkersHousingKey = 'dashboard-workers-housing';
  static const String dashboardHealthCertificateKey = 'dashboard-health-certificate';
  static const String dashboardBaladyReportKey = 'dashboard-balady-report';
  static const String dashboardEffectivenessPermitKey = 'dashboard-effectiveness-permit';

  // book-appointment-appointment-info drop-down keys
  static const String bookAppointmentInfoMunicipalityDropdownKey = 'book-appointment-info-municipality-drop-down';
  static const String bookAppointmentInfoMunicipalDropdownKey = 'book-appointment-info-municipal-drop-down';
  static const String bookAppointmentInfoDesiredServiceDropdownKey = 'book-appointment-info-desired-service-drop-down';

  static const String contactUsMessagesTypes = 'contact_us_messages_types';

  // book-appointment-appointment-info fields keys
  static const String bookAppointmentInfoServiceNumberKey = 'book-appointment-info-service-number';
  static const String bookAppointmentInfoNotesKey = 'book-appointment-info-notes';

  //
  static const String bookAppointmentInfoTypeKey = 'book-appointment-info-type';
  static const String bookAppointmentInfoAttachmentKey = 'book-appointment-info-attachment';
  static const String bookAppointmentInfoSpecialNeedsKey = 'book-appointment-info-special-needs';
  static const String bookAppointmentDateKey = 'book-appointment-date';
  static const String bookAppointmentTimeKey = 'book-appointment-time';

  // customer voice
  static const String customerVoiceAppointmentCardKey = 'customer-voice-appointment-card';
  static const String customerVoiceInquiriesCardKey = 'customer-voice-inquiries-card';
  static const String customerVoiceReportsCardKey = 'customer-voice-reports-card';
  static const String customerVoiceTechnicalSupportCardKey = 'customer-voice-technical-support-card';
  static const String customerVoiceMoreCardKey = 'customer-voice-more-card';
  static const String customerVoiceComplaintCardKey = 'customer-voice-complaint-card';
  static const String customerVoiceRequestServiceCardKey = 'customer-voice-request-service-card';
  static const String customerVoiceObjectionCardKey = 'customer-voice-objection-card';
  static const String customerVoiceTakePictureAndUploadCardKey = 'customer-voice-take-picture-and-upload-card';
  static const String customerVoiceMaintenanceCardKey = 'customer-voice-maintenance-card';
  static const String customerVoiceConstructionCardKey = 'customer-voice-construction-card';
  static const String customerVoiceLandsCardKey = 'customer-voice-lands-card';
  static const String customerVoiceMarketAndStoreCardKey = 'customer-voice-market-and-store-card';
  static const String customerVoiceFloodsCardKey = 'customer-voice-floods-card';

  static const String customerVoicePetsCardKey = 'customer-voice-pets-card';
  static const String customerVoiceAllCardKey = 'customer-voice-all-card';
  static const String customerVoiceUrbanLandscapeReportKey = 'customer-voice-urban-landscape-report';
  static const String generalInquiresKey = 'general-inquires';
  static const String inquiryAboutTransactionKey = 'inquiry-about-transaction';

  // Guest keys
  static const String guestFirstName = 'guest_first_name';
  static const String guestLastName = 'guest_last_name';
  static const String guestMobile = 'guest-mobile';

  // license management keys
  static const String licenseKey = 'license-key';
  static const String ordersKey = 'orders-key';
  static const String billsKey = 'bills-key';

  /// icons
  // bottom navigation bar icons
  static const String bottomNavigationBarHomeIcon = 'assets/icons/bottom_navigation_bar_home_icon.svg';
  static const String bottomNavigationBarServicesDirectoryIcon =
      'assets/icons/bottom_navigation_bar_services_directory_icon.svg';
  static const String bottomNavigationBarStoreIcon = 'assets/icons/bottom_nav_store.svg';
  static const String bottomNavigationBarDigitalWalletIcon =
      'assets/icons/bottom_navigation_bar_digital_wallet_icon.svg';
  static const String bottomNavigationBarMoreIcon = 'assets/icons/bottom_navigation_bar_more_icon.svg';

  // shared icons
  static const String logoTextIcon = 'assets/icons/logo_text.svg';
  static const String logoSymbolIcon = 'assets/icons/logo_symbol.svg';
  static const String logoSymbolWithWhiteBGIcon = 'assets/icons/logo_symbol_with_white_bg.svg';
  static const String logoSymbolWithTextIcon = 'assets/icons/logo_symbol_with_text_icon.svg';
  static const String splashScreenBaladyLogoIcon = 'assets/icons/splash_screen_balady_logo.svg';
  static const String largeBaladyLogoIcon = 'assets/icons/headerLargeLogo.svg';
  static const String coloredLogoIcon = 'assets/icons/coloredLogo.svg';
  static const String arrowBackIcon = 'assets/icons/arrow_back_icon.svg';
  static const String lightIcon = 'assets/icons/light_icon.svg';
  static const String feeCalculatorIcon = 'assets/icons/fee_calculator_icon.svg';
  static const String pinLocationIcon = 'assets/icons/pin_location_icon.svg';
  static const String starIcon = 'assets/icons/star_icon.svg';
  static const String timeIcon = 'assets/icons/time_icon.svg';
  static const String dateIcon = 'assets/icons/date_icon.svg';
  static const String locationIcon = 'assets/icons/location_icon.svg';
  static const String cityIcon = 'assets/icons/city_icon.svg';
  static const String hashtagIcon = 'assets/icons/hashtag_icon.svg';
  static const String appointmentIcon = 'assets/icons/appointment_icon.svg';
  static const String appointmentInfoIcon = 'assets/icons/appointment_info_icon.svg';
  static const String appointmentTypeIcon = 'assets/icons/appointment_type_icon.svg';
  static const String successfulBookNewAppointmentIcon = 'assets/icons/successful_book_new_appointment_icon.svg';
  static const String attachmentIcon = 'assets/icons/attachment_icon.svg';
  static const String shareIcon = 'assets/icons/share_icon.svg';
  static const String fileIcon = 'assets/icons/file_icon.svg';
  static const String qrCodeRoundedIcon = 'assets/icons/qr_code_rounded_icon.svg';
  static const String dashboardIcon = 'assets/icons/dashboard_icon.svg';
  static const String buildingsIcon = 'assets/icons/buildings_icon.svg';
  static const String profileIcon = 'assets/icons/profile_icon.svg';
  static const String infoIcon = 'assets/icons/info_icon.svg';
  static const String ratingIcon = 'assets/icons/rating_icon.svg';
  static const String contactUsIcon = 'assets/icons/contact_us_icon.svg';
  static const String settingsIcon = 'assets/icons/settings_icon.svg';
  static const String logoutIcon = 'assets/icons/logout_icon.svg';
  static const String instructionsIcon = 'assets/icons/instructions_icon.svg';
  static const String finsIcon = 'assets/icons/fins.svg';
  static const String requirementsIcon = 'assets/icons/requirements_icon.svg';
  static const String termsAndApprovalIcon = 'assets/icons/terms_and_approval_icon.svg';
  static const String requirementsIcon1 = 'assets/icons/ServiceProcess.svg';
  static const String stepsIcon = 'assets/icons/ServiceRegulations.svg';
  static const String applicationStepsIcon = 'assets/icons/application_steps_icon.svg';
  static const String feesIcon = 'assets/icons/fees.svg';
  static const String finsGreenIcon = 'assets/icons/fines.svg';
  static const String notesPrecautionIcon = 'assets/icons/notes_precaution_icon.svg';
  static const String licenseManagementIcon = 'assets/icons/license_management_icon.svg';
  static const String newInformationCardIcon = 'assets/icons/new_information_card_icon.svg';
  static const String notFoundPageIcon = 'assets/icons/not_found_page_icon.svg';
  static const String tempIcon = 'assets/icons/temp_icon.svg';
  static const String mobileIcon = 'assets/icons/mobile_icon.svg';
  static const String computerIcon = 'assets/icons/computer_icon.svg';
  static const String walletIcon = 'assets/icons/wallet_icon.svg';
  static const String groupOfUsersIcon = 'assets/icons/group_of_users_icon.svg';
  static const String numberOfServicesIcon = 'assets/icons/number_of_services_icon.svg';
  static const String touchIdIcon = 'assets/icons/touch_id_icon.svg';
  static const String faceIdIcon = 'assets/icons/faceIdIcon.svg';

  static const String pinCodeSecretIcon = 'assets/icons/pin_code_secret_icon.svg';
  static const String pinCodeSecretIcon2 = 'assets/icons/pin_code_secret_icon2.svg';

  // home apps icons
  static const String calculatorAppIcon = 'assets/icons/iconMiniAppCalculator.svg';
  static const String extraAppIcon = 'assets/icons/iconMiniAppExtraIcon.svg';
  static const String furasAppIcon = 'assets/icons/iconMiniAppFours.svg';
  static const String licenceManagementAppIcon = 'assets/icons/iconMiniAppLicenseMangment.svg';
  static const String ratingAppIcon = 'assets/icons/iconMiniAppRatingApp.svg';
  static const String EnquiriesAppIcon = 'assets/icons/iconMiniAppIllustrationEnquiries.svg';
  static const String VisitAppIcon = 'assets/icons/iconMiniAppIllustrationCompliancePartner.svg';
  static const String slaughterAppIcon = 'assets/icons/iconMiniAppSlaughter.svg';
  //static const String ekramAppIcon =
  //   'assets/icons/ekram.svg';
  static const String ekramAppIcon = 'assets/icons/ekramNew.svg';

  // license services icons
  static const String licenseServicesNewLicenseIcon = 'assets/icons/license_services_new_license_icon.svg';
  static const String licenseServicesCancelLicenseIcon = 'assets/icons/license_services_cancel_license_icon.svg';
  static const String licenseServicesEditLicenseIcon = 'assets/icons/license_services_edit_license_icon.svg';
  static const String licenseServicesRenewLicenseIcon = 'assets/icons/license_services_renew_license_icon.svg';
  static const String licenseServicesTransferOwnershipLicenseIcon =
      'assets/icons/license_services_transfer_ownership_license_icon.svg';

  static const String licenseServicesPtintLicenseIcon = 'assets/icons/printLicense.svg';

  // service directory icons
  static const String servicesDirectoryCommercialLicensesIcon =
      'assets/icons/services_directory_commercial_licenses_icon.svg';
  static const String servicesDirectoryConstructionLicensesIcon =
      'assets/icons/services_directory_construction_licenses_icon.svg';
  static const String servicesDirectoryArealResolutionIcon =
      'assets/icons/services_directory_areal_resolution_icon.svg';
  static const String servicesDirectoryOperatingLicensesIcon =
      'assets/icons/services_directory_operating_licenses_icon.svg';
  static const String servicesDirectoryGrantServicesIcon = 'assets/icons/services_directory_grant_services_icon.svg';
  static const String servicesDirectoryLandAndPropertyIcon =
      'assets/icons/services_directory_land_and_property_icon.svg';
  static const String servicesDirectoryMunicipalOversightIcon =
      'assets/icons/services_directory_municipal_oversight_icon.svg';
  static const String servicesDirectoryShelterFacilitiesIcon =
      'assets/icons/services_directory_shelter_facilities_icon.svg';
  static const String servicesDirectoryOpticalDistortionIcon =
      'assets/icons/services_directory_optical_distortion_icon.svg';
  static const String servicesDirectoryFossilsServicesIcon =
      'assets/icons/services_directory_fossils_services_icon.svg';

  // dashboard icons
  static const String dashboardCommercialLicenseIcon = 'assets/icons/dashboard_commercial_license_icon.svg';
  static const String dashboardConstructionLicenseIcon = 'assets/icons/dashboard_construction_license_icon.svg';
  static const String dashboardArealResolutionIcon = 'assets/icons/dashboard_areal_resolution_icon.svg';
  static const String dashboardWorkersHousingIcon = 'assets/icons/dashboard_workers_housing_icon.svg';
  static const String dashboardHealthCertificateIcon = 'assets/icons/dashboard_health_certificate_icon.svg';
  static const String dashboardBaladyReportIcon = 'assets/icons/dashboard_balady_report_icon.svg';
  static const String dashboardEffectivenessPermitIcon = 'assets/icons/dashboard_effectiveness_permit_icon.svg';

  // appointment icons
  static const String appointmentNewAppointmentIcon = 'assets/icons/appointment_new_appointment_icon.svg';
  static const String appointmentReviewAppointmentIcon = 'assets/icons/appointment_review_appointment_icon.svg';
  static const String appointmentBookNewAppointmentIcon = 'assets/icons/appointment_book_new_appointment_icon.svg';

  // customer voice icons
  static const String customerVoiceIcon = 'assets/icons/customer_voice_icon.svg';
  static const String customVoiceCommonReportIcon = 'assets/icons/customer_voice_common_report_icon.svg';
  static const String customerVoiceFollowUpReportsIcon = 'assets/icons/customer_voice_follow_up_reports_icon.svg';
  static const String customerVoiceInquiriesIcon = 'assets/icons/customer_voice_inquiries_icon.svg';
  static const String customerVoiceMoreIcon = 'assets/icons/customer_voice_more_icon.svg';
  static const String customerVoiceReportsIcon = 'assets/icons/customer_voice_reports_icon.svg';
  static const String customerVoiceTechnicalSupportIcon = 'assets/icons/customer_voice_technical_support_icon.svg';
  static const String customerVoiceAllIcon = 'assets/icons/customer_voice_all_icon.svg';
  static const String customerVoiceAllCardIcon = 'assets/icons/iconInnerPageCardCustomerVoiceReportAllIncident.svg';
  static const String customerVoiceComplaintIcon = 'assets/icons/customer_voice_complaint_icon.svg';
  static const String customerVoiceTakePictureAndUploadIcon =
      'assets/icons/iconServicesCustomerVoiceShootSendWeSolve.svg';
  static const String customerVoiceTakePictureAndUploadCardIcon =
      'assets/icons/iconInnerPageCardCustomerVoiceSnapAndSendService.svg';
  static const String customerVoiceLandsIcon = 'assets/icons/iconServicesCustomerVoiceAssetsAndFacilities.svg';
  static const String customerVoiceLandsCardIcon = 'assets/icons/iconInnerPageCardCustomerVoiceAssetsAndFacilities.svg';
  static const String customerVoiceFloodsIcon = 'assets/icons/iconServicesCustomerVoiceFloodDisaster.svg';
  static const String customerVoiceFloodsCardIcon = 'assets/icons/iconInnerPageCardCustomerVoiceFloodDisaster.svg';
  static const String customerVoiceMaintenanceIcon = 'assets/icons/customer_voice_maintenance_icon.svg';
  static const String customerVoiceConstructionIcon = 'assets/icons/iconServicesCustomerVoiceBuildling.svg';
  static const String customerVoiceConstructionCardIcon = 'assets/icons/iconInnerPageCardCustomerVoiceBuilding.svg';
  static const String customerVoiceMarketAndStoreIcon = 'assets/icons/customer_voice_market_and_store_icon.svg';
  static const String customerVoiceMarketAndStoreCardIcon = 'assets/icons/iconInnerPageCardCustomerVoiceMarket.svg';
  static const String customerVoiceObjectionIcon = 'assets/icons/customer_voice_objection_icon.svg';
  static const String customerVoicePetsIcon = 'assets/icons/customer_voice_pets_icon.svg';
  static const String customerVoicePetsCardIcon = 'assets/icons/iconInnerPageCardCustomerVoicePets.svg';
  static const String customerVoiceRequestServiceIcon = 'assets/icons/customer_voice_request_service_icon.svg';
  static const String customerVoiceComplaintIconCard = 'assets/icons/iconInnerPageCardCustomerVoiceCompliant.svg';
  static const String customerVoiceTechnicalSupportIconCard =
      'assets/icons/iconInnerPageCardCustomerVoiceCustomerSupport.svg';
  static const String customerVoiceReportsIconCard = 'assets/icons/iconInnerPageCardCustomerVoiceReportAnIncident.svg';
  static const String customerVoiceInquiriesIconCard = 'assets/icons/iconInnerPageCardCustomerVoiceFaq.svg';
  static const String customerVoiceRequestServiceIconCard =
      'assets/icons/iconInnerPageCardCustomerVoiceRequestANewService.svg';

  static const String generalInquiresKeyIconCard = 'assets/icons/iconCard60FaqSVG.svg';

  static const String inquiryAboutTransactionKeyIconCard = 'assets/icons/iconCard60EnquirySVG.svg';

  static const String customerVoiceHelpFilesIcon = 'assets/icons/listItemCustomerVoiceFilterIconHelpFiles.svg';
  static const String customerVoiceImagesIcon = 'assets/icons/listItemCustomerVoiceFilterIconImages.svg';
  static const String customerVoiceLinkIcon = 'assets/icons/listItemCustomerVoiceFilterIconLink.svg';
  static const String customerVoiceTextIcon = 'assets/icons/listItemCustomerVoiceFilterIconText.svg';
  static const String customerVoiceVideoIcon = 'assets/icons/listItemCustomerVoiceFilterIconVideo.svg';

  static const String informationIcon = 'assets/icons/informationCircle.svg';
  static const String helpMaterialIcon = 'assets/icons/commonFileTextQuestion.svg';

  // licence management icon
  static const String licenceIcon = 'assets/icons/iconServicesLicenses.svg';
  static const String ordersIcon = 'assets/icons/iconServicesCustomerVoiceRequestANewService.svg';
  static const String billsIcon = 'assets/icons/iconServicesLicenseManagementBills.svg';

  /// Declaration
  static const String declarationMapKey = 'declaration_map';
  static const String declarationNumbersKey = 'declaration_numbers';
  static const String declarationQrCodeKey = 'guest-declaration_qr_code';
  static const String declarationMap = 'assets/icons/DeclarationMap.svg';
  static const String declarationNumbers = 'assets/icons/DeclarationNumbers.svg';
  static const String declarationQrCode = 'assets/icons/DeclarationQrCode.svg';

  /// images
  static const String imgPath = 'assets/images/';
  static const String splashScreenBaladySecondLogoImg = 'assets/images/splash_screen_balady_second_logo.png';
  static const String splashScreen2030LogoImg = 'assets/images/2030Logo@3x.png';
  static const String splashScreenQualityLogoImg = 'assets/images/qualityLogo@3x.png';
  static const String moreScreen2030LogoImg = 'assets/images/2030MoreLogo@3x.png';
  static const String moreScreenQualityLogoImg = 'assets/images/qualityMoreLogo@3x.png';

  static const String newInformationCardImg = 'assets/images/newInfoBackground@3x.png';
  static const String calculatorCardImg = 'assets/images/calculatorBackground@3x.png';
  static const String homeCardImg = 'assets/images/card_background@3x.png';
  static const String placeholderImg = 'assets/images/placeholder.jpg';
  static const String deliveryTruckImg = 'assets/images/delivery_truck.png';
  static const String imageNotAvailableImg = 'assets/images/image_not_available.png';
  static const String userProfilePlaceholderImg = 'assets/images/user_profile_placeholder.png';
  static const String updateTermsImg = 'assets/images/update_terms.jpg';
  static const String whiteCloseImg = 'assets/images/white_close@3x.png';
  static const String backImg = 'assets/images/arrowBack@3x.png';
  static const String userProfileImg = 'assets/images/user_profile@2x.png';
  static const String digitalWalletCardImg = 'assets/images/digital_wallet_card@3x.png';
  static const String digitalWalletQRCodeCardImg = 'assets/images/digital_wallet_qr_code_card@3x.png';

  static const String digitalWalletEmptyStateImg = "emptyWalletIllustration@3x.png";
  static const String checkImg = 'assets/images/check.png';
  static const String homeSliderCardImg = 'assets/images/home_slider_card_{}.png';
  static const String privacyPinIcon = 'assets/icons/listItem24PinCode.svg';
  static const String privacyFaceIcon = 'assets/icons/listItem24FaceId.svg';
  static const String privacyChangePinIcon = 'assets/icons/listItem24ChangePinCode.svg';
  static const String privacyIcon = 'assets/icons/listItem24PrivacyAndSecurity.svg';

  static const String BookNewVisitIcon = 'assets/icons/iconServicesVisit.svg';

  // Addetional Fields
  static const String Textbox = 'Textbox';
  static const String DropdownList = 'DropdownList';
  static const String TextArea = 'TextArea';

  static const String Radiobutton = 'Radiobutton';

  static const String HijriCalendar = 'Hijri Calendar';

  static const String GregorianCalendar = 'Gregorian Calendar';

  static const String Numbersfield = 'Numbersfield';
  static const String MultiSelectDropdown = 'MultiSelect Dropdown';

  // Map Icons
  static const String mapMarkerLocation = 'assets/images/location@3x.webp';

  static const String userMarkerLocation = 'assets/images/useLocation@3x.webp';

  static const String pinDarkGreenMarkerLocation = 'assets/images/pinMarkerDarkGreen.webp';

  static const String pinLightGreenMarkerLocation = 'assets/images/pinMarkerLightGreen.webp';

  // Deep Links
  static const String customerSoundDeepLinkUrl = 'customervoice';
  static const String qrDeepLinkUrl = 'qrcode/qr/exp';

  // Inq Icons
  static const String Inq_1 = 'assets/images/inq/Inq_1.svg';
  static const String Inq_2 = 'assets/images/inq/Inq_2.svg';
  static const String Inq_3 = 'assets/images/inq/Inq_3.svg';
  static const String Inq_4 = 'assets/images/inq/Inq_4.svg';
  static const String Inq_5 = 'assets/images/inq/Inq_5.svg';
  static const String Inq_6 = 'assets/images/inq/Inq_6.svg';
  static const String Inq_7 = 'assets/images/inq/Inq_7.svg';
  static const String Inq_8 = 'assets/images/inq/Inq_8.svg';
  static const String Inq_9 = 'assets/images/inq/Inq_9.svg';
  static const String Inq_10 = 'assets/images/inq/Inq_10.svg';
  static const String Inq_11 = 'assets/images/inq/Inq_11.svg';
  static const String Inq_12 = 'assets/images/inq/Inq_12.svg';
  static const String Inq_13 = 'assets/images/inq/Inq_13.svg';
  static const String Inq_14 = 'assets/images/inq/Inq_14.svg';
}
