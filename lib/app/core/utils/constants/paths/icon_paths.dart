const _svgIconPath = 'assets/icons/svg/';
const _svgPrayerIconPath = 'assets/icons/svg/prayers/';
const _svgWeatherIconPath = 'assets/icons/svg/weather/';
const _svgMapIconPath = 'assets/icons/svg/map/';
const _svgServicesIconPath = 'assets/icons/svg/services/';
const _svgProfileIconPath = 'assets/icons/svg/profile/';
const _svgNearbyIconPath = 'assets/icons/svg/nearby/';
const _pngVDIconPath = 'assets/icons/png/vd/';
const _svgVDIconPath = 'assets/icons/svg/vd/';
const _svgAthkarIconPath = 'assets/icons/svg/athkar/';

const _pngQRIconPath = 'assets/icons/png/qr/';
const _svgQRIconPath = 'assets/icons/svg/qr/';

const _svg = '.svg';

const _pngIconPath = 'assets/icons/png/';
const _png = '.png';

class IconPath {
  //! SVG Icons
  static const arrowBack = '${_svgIconPath}arrow_back_icon$_svg';
  static const close = '${_svgIconPath}arrow_back_icon$_svg';
  static const upload = '${_svgIconPath}arrow_back_icon$_svg';
  static const search = '${_svgIconPath}search_icon$_svg';
  static const filter = '${_svgIconPath}filter$_svg';
  static const appBarSearch = '${_svgIconPath}appbar_search$_svg';
  static const billIcon = '${_svgIconPath}bill_icon$_svg';
  static const placeholder = '${_svgIconPath}placeholder$_svg';
  static const add = '${_svgIconPath}add$_svg';
  static const pdf = '${_svgIconPath}PDF$_svg';
  static const informationCircleIcon =
      '${_svgIconPath}informationCircleIcon$_svg';

  static const ksaFlag = '${_svgIconPath}ksaFlag$_svg';
  static const ksaWord = '${_svgIconPath}ksaWord$_svg';
  static const otpLogo = '${_pngIconPath}shield$_png';
  static const needLogin = '${_pngIconPath}need_login$_png';
  static const successIcon = '${_pngIconPath}success_icon$_png';

  // Bottom-Nav-Bar
  static const home = '${_svgIconPath}home_icon$_svg';
  static const services = '${_svgIconPath}services_icon$_svg';
  static const nearby = '${_svgIconPath}nearby_icon$_svg';
  static const profile = '${_svgIconPath}profile_icon$_svg';

  // Prayers
  static const fajr = '${_svgPrayerIconPath}iconSalahFajer$_svg';
  static const dhuhr = '${_svgPrayerIconPath}iconSalahZuhar$_svg';
  static const asr = '${_svgPrayerIconPath}iconSalahAsr$_svg';
  static const maghrib = '${_svgPrayerIconPath}iconSalahMaghreb$_svg';
  static const isha = '${_svgPrayerIconPath}iconSalahIsha$_svg';

  // Services
  static serviceIcon(String name) => '$_svgServicesIconPath$name$_svg';
  static const rating = '${_svgServicesIconPath}rating$_svg';
  static const duration = '${_svgServicesIconPath}duration$_svg';
  static const warnings = '${_svgServicesIconPath}warnings$_svg';

  // Profile
  static const profileIcon = '${_svgProfileIconPath}user$_svg';
  static const personalInformation = '${_svgProfileIconPath}user$_svg';
  static const dashboard = '${_svgProfileIconPath}dashboard$_svg';
  static const requests = '${_svgProfileIconPath}requests$_svg';
  static const licenses = '${_svgProfileIconPath}licenses$_svg';
  static const invoices = '${_svgProfileIconPath}invoices$_svg';
  static const reports = '${_svgProfileIconPath}user$_svg';
  static const violations = '${_svgProfileIconPath}violations$_svg';
  static const objections = '${_svgProfileIconPath}objections$_svg';
  static const appiontments = '${_svgProfileIconPath}appiontments$_svg';
  static const settings = '${_svgProfileIconPath}settings$_svg';
  static const help = '${_svgProfileIconPath}help$_svg';
  static const rateApp = '${_svgProfileIconPath}settings$_svg';
  static const aboutBalady = '${_svgProfileIconPath}about_balady$_svg';
  static const arrowDown = '${_svgProfileIconPath}arrow_down$_svg';
  static const contactInfo = '${_svgProfileIconPath}contact_info$_svg';
  static const leftArrow = '${_svgProfileIconPath}left_arrow$_svg';

  // Nearby
  static nearbyIcon(String name) => '$_svgNearbyIconPath$name$_svg';

  // Weather
  static const partlyClouded = '${_svgWeatherIconPath}partly_clouded$_svg';

  // Map
  static const layers = '${_svgMapIconPath}layers$_svg';
  static const currentLocation = '${_svgMapIconPath}current_location$_svg';

  //! PNG Icons
  static const arrowForward = '${_pngIconPath}arrow_forward_icon$_png';
  static const logo = '${_pngIconPath}logo_icon$_png';

  static const logoSymbolIcon = '${_svgIconPath}logo_symbol$_svg';
  static const logoTextIcon = '${_svgIconPath}logo_text$_svg';
  static const splashScreenBaladySecondLogoImg =
      '${_pngIconPath}splash_screen_balady_second_logo$_png';
  static const splashScreen2030LogoImg = '${_pngIconPath}2030Logo@3x$_png';
  static const splashScreenQualityLogoImg = '${_pngIconPath}qualityLogo$_png';

//! Splash Screen

  static const arrowLeft = '${_svgIconPath}arrow-left$_svg';

//! VD
  static const vdSearchIcon = '${_pngVDIconPath}vd_search$_png';
  static const vdCancelIcon = '${_pngVDIconPath}vd_cancel_icon$_png';
  static const vdSwipeIcon = '${_pngVDIconPath}swipe_vd$_png';
  static const vdmapSearchIcon = '${_pngVDIconPath}mapSearch@3x$_png';
  static const vdlocationIcon = '${_pngVDIconPath}location1@3x$_png';
  static const vdFlashOnIcon = '${_pngVDIconPath}flash-on$_png';
  static const vdFlashOffIcon = '${_pngVDIconPath}flash-off$_png';
  static const vdFlashOn1Icon = '${_pngVDIconPath}flash_on@3x$_png';
  static const vdFlashOff1Icon = '${_pngVDIconPath}flash_off@3x$_png';
  static const vdButtonCameraIcon = '${_pngVDIconPath}buttonCamera@3x$_png';
  static const vdarrowLeftIcon = '${_pngVDIconPath}arrowLeftSLightCopy@3x$_png';
  static const vdAgianIcon = '${_pngVDIconPath}again@3x$_png';
  static const vdMapMarkerIcon = '${_pngVDIconPath}marker2@3x$_png';
  static const vdFlashOffIcon2 = '${_svgVDIconPath}Flash-off$_svg';
  static const vdSplSearch = '${_svgVDIconPath}vd_spl_search$_svg';

  static const vdSplSearchExit = '${_svgVDIconPath}vd_spl_search_exit$_svg';

  static const vdCameraFlashOn = '${_svgVDIconPath}FlashOn$_svg';
  static const vdCameraFlashOff = '${_svgVDIconPath}FlashOf$_svg';
  static const vdCameraFlashRetry = '${_svgVDIconPath}retry$_svg';
  static const vdCameraExit = '${_svgVDIconPath}vdCameraExit$_svg';

  static const vdAppBarBack = '${_svgVDIconPath}vdAppBarArrow$_svg';

  static const vdSummuryDesc = '${_svgVDIconPath}vdSummuryDesc$_svg';
  static const vdSummuryPhoto = '${_svgVDIconPath}vdSummuryPhoto$_svg';
  static const vdSummuryPledge = '${_svgVDIconPath}vdSummuryPledge$_svg';
  static const vdSummurySPL = '${_svgVDIconPath}vdSummurySPL$_svg';
  static const vdSummuryUserInfo = '${_svgVDIconPath}vdSummuryUserInfo$_svg';

//! QR
  static const qrScanImageIcon = '${_pngQRIconPath}scan_img@3x$_png';
  static const qrWhiteCloseIcon = '${_pngQRIconPath}white_close@3x$_png';
  static const qrWhiteExitIcon = '${_pngQRIconPath}white_exit@3x$_png';
  static const qrbackIconIcon = '${_pngQRIconPath}iconStrokeLeft@3x$_png';
  static const qrStarsIcon = '${_pngQRIconPath}stars@3x$_png';

  static const qrNotAvailableIcon = '${_pngQRIconPath}notAvailable@3x$_png';
  static const qrAvailableIcon = '${_pngQRIconPath}available@3x$_png';
  static const qrGreyCloseIcon = '${_pngQRIconPath}grey_close@3x$_png';
  static const qrArrowDownIcon = '${_pngQRIconPath}arrowDowng@3x$_png';
  static const qrArrowUpIcon = '${_pngQRIconPath}arrowUp@3x$_png';

  static const qrCallIcon = '${_svgQRIconPath}qr_call$_svg';
  static const qrClockIcon = '${_svgQRIconPath}qr_clock$_svg';
  static const qrLocationIcon = '${_svgQRIconPath}qr_location$_svg';
  static const qrRatingIcon = '${_svgQRIconPath}qr_rating$_svg';
  static const qrSocialIcon = '${_svgQRIconPath}qr_social$_svg';
  static const qrWebIcon = '${_svgQRIconPath}qr_web$_svg';

  static const qrFaceBookIcon = '${_svgQRIconPath}Facebook$_svg';
  static const qrInstagramIcon = '${_svgQRIconPath}Instagram$_svg';
  static const qrSnapChatIcon = '${_svgQRIconPath}Snapchat$_svg';
  static const qrTwitterIcon = '${_svgQRIconPath}Twitter$_svg';
  static const qrWhatsupIcon = '${_svgQRIconPath}WhatsApp$_svg';

  static const qrOpenLinkIcon = '${_svgQRIconPath}open_link$_svg';
  static const qrRatingStarIcon = '${_svgQRIconPath}qr_rating_star$_svg';

  static const qrParkingServiceIcon =
      '${_svgQRIconPath}qr_parking_service$_svg';
  static const qrParkingIcon = '${_svgQRIconPath}qr_parking$_svg';
  static const qrDeliveryServiceIcon =
      '${_svgQRIconPath}qr_delivery_service$_svg';
  static const qrDisableIcon = '${_svgQRIconPath}qr_disable$_svg';

  static const qrAIcon = '${_pngQRIconPath}tours_rating_icons/a$_png';
  static const qrBIcon = '${_pngQRIconPath}tours_rating_icons/b$_png';
  static const qrCIcon = '${_pngQRIconPath}tours_rating_icons/c$_png';
  static const qrDIcon = '${_pngQRIconPath}tours_rating_icons/d$_png';
  static const qrLockIcon = '${_pngQRIconPath}tours_rating_icons/lock$_png';

  static const qrStarIcon = '${_pngQRIconPath}greyStar$_png';

  //Athkar

  static const morningAthkarIcon = '${_svgAthkarIconPath}morning_athkar$_svg';
  static const sleepingAthkarIcon = '${_svgAthkarIconPath}evening_athkar$_svg';
  static const eveningAthkarIcon = '${_svgAthkarIconPath}sleeping_athkar$_svg';
  static const reset = '${_svgAthkarIconPath}reset$_svg';

  static const muslimNumberFrame =
      '${_svgAthkarIconPath}muslim_number_frame$_svg';
}
