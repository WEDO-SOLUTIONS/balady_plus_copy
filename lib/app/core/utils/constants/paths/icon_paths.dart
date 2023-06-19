const _svgIconPath = 'assets/icons/svg/';
const _svgPrayerIconPath = 'assets/icons/svg/prayers/';
const _svgWeatherIconPath = 'assets/icons/svg/weather/';
const _svgMapIconPath = 'assets/icons/svg/map/';
const _svgServicesIconPath = 'assets/icons/svg/services/';
const _svgProfileIconPath = 'assets/icons/svg/profile/';
const _svgNearbyIconPath = 'assets/icons/svg/nearby/';
const _pngVDIconPath = 'assets/icons/png/vd/';
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
  static const vdarrowLeftIcon = '${_pngVDIconPath}arrowLeft$_png';
  static const vdAgianIcon = '${_pngVDIconPath}again@3x$_png';
  static const vdMapMarkerIcon = '${_pngVDIconPath}marker2@3x$_png';
}
