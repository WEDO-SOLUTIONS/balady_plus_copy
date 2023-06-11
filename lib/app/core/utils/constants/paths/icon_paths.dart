const _svgIconPath = 'assets/icons/svg/';
const _svgPrayerIconPath = 'assets/icons/svg/prayers/';
const _svgWeatherIconPath = 'assets/icons/svg/weather/';
const _svgMapIconPath = 'assets/icons/svg/map/';
const _svgServicesIconPath = 'assets/icons/svg/services/';
const _svg = '.svg';

const _pngIconPath = 'assets/icons/png/';
const _png = '.png';

class IconPath {
  //! SVG Icons
  static const arrowBack = '${_svgIconPath}arrow_back_icon$_svg';
  static const close = '${_svgIconPath}arrow_back_icon$_svg';
  static const upload = '${_svgIconPath}arrow_back_icon$_svg';
  static const search = '${_svgIconPath}search_icon$_svg';

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
}
