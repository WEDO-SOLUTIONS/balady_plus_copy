const _svgIconPath = 'assets/icons/svg/';
const _svgPrayerIconPath = 'assets/icons/svg/prayers/';
const _svgWeatherIconPath = 'assets/icons/svg/weather/';
const _svgEtmamAppIconPath = 'assets//etmam_app/icons/svg/';
const _svgMapIconPath = 'assets/icons/svg/map/';
const _svgServicesIconPath = 'assets/icons/svg/services/';
const _svgProfileIconPath = 'assets/icons/svg/profile/';
const _svgNearbyIconPath = 'assets/icons/svg/nearby/';
const _pngVDIconPath = 'assets/icons/png/vd/';
const _svgVDIconPath = 'assets/icons/svg/vd/';
const _svgAthkarIconPath = 'assets/icons/svg/athkar/';
const _boardingLogoPath = 'assets/icons/svg/boarding/';

const _pngQRIconPath = 'assets/icons/png/qr/';
const _svgQRIconPath = 'assets/icons/svg/qr/';

const _svgCRIconPath = 'assets/icons/svg/cr/';
const _svgWalletIconPath = 'assets/icons/svg/wallet/';
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
  static const calender = '${_svgIconPath}calender$_svg';
  static const send = '${_svgIconPath}send$_svg';
  static const chat = '${_svgIconPath}chat$_svg';
  static const marker = '${_svgIconPath}marker$_svg';
  static const add = '${_svgIconPath}add$_svg';
  static const pdf = '${_svgIconPath}PDF$_svg';
  static const settingsIcon = '${_svgIconPath}settings$_svg';
  static const printer = '${_svgIconPath}printer$_svg';
  static const routeSquare = '${_svgIconPath}route-square$_svg';
  static const suraIcon = '${_svgIconPath}sura_icon$_svg';
  static const warningIcon = '${_svgIconPath}danger$_svg';
  static const notificationIc = '${_svgIconPath}notification$_svg';
  static const notificationIc2 = '${_svgIconPath}notification2$_svg';
  static const notificationFilled = '${_svgIconPath}notification_filled$_svg';

  static const arrowForward2 = '${_svgIconPath}arrow_forward$_svg';
  static const receiveSquare = '${_svgIconPath}receive-square$_svg';
  static const note2 = '${_svgIconPath}note_2$_svg';
  static const call = '${_svgIconPath}call$_svg';
  static const global = '${_svgIconPath}global$_svg';
  static const mobile = '${_svgIconPath}mobile$_svg';
  static const magicStar = '${_svgIconPath}magic_star$_svg';
  static const dollarCircle = '${_svgIconPath}dollar_circle$_svg';
  static const stopCircle = '${_svgIconPath}stop_circle$_svg';
  static const download = '${_svgIconPath}download$_svg';
  static const download2 = '${_svgIconPath}download2$_svg';
  static const moneyTime = '${_svgIconPath}money_time$_svg';
  static const infoCircle = '${_svgIconPath}info_circle$_svg';
  static const camera = '${_svgIconPath}camera$_svg';
  static const location = '${_svgIconPath}location$_svg';

  static const informationCircleIcon =
      '${_svgIconPath}informationCircleIcon$_svg';

  static const ksaFlag = '${_svgIconPath}ksaFlag$_svg';
  static const ksaWord = '${_svgIconPath}ksaWord$_svg';
  static const otpLogo = '${_pngIconPath}shield$_png';
  static const needLogin = '${_pngIconPath}need_login$_png';
  static const successIcon = '${_pngIconPath}success_icon$_png';
  static const calenderTick = '${_svgIconPath}calender_tick$_svg';

  static const documentCopy = '${_svgIconPath}document_copy$_svg';
  static const arrowRight = '${_svgIconPath}arrow-right$_svg';

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
  static const helpNew = '${_svgProfileIconPath}help_new$_svg';
  static const rateApp = '${_svgProfileIconPath}settings$_svg';
  static const aboutBalady = '${_svgProfileIconPath}about_balady$_svg';
  static const arrowDown = '${_svgProfileIconPath}arrow_down$_svg';
  static const contactInfo = '${_svgProfileIconPath}contact_info$_svg';
  static const leftArrow = '${_svgProfileIconPath}left_arrow$_svg';
  static const wallet = '${_svgProfileIconPath}wallet$_svg';

  // Nearby
  static nearbyIcon(String name) => '$_svgNearbyIconPath$name$_svg';

  // Weather
  static const partlyClouded = '${_svgWeatherIconPath}partly_clouded$_svg';
  static const humedity = '${_svgWeatherIconPath}humedity$_svg';

  static const sunset = '${_svgWeatherIconPath}sunset$_svg';
  static const sunrise = '${_svgWeatherIconPath}sunrise$_svg';
  static const sun = '${_svgWeatherIconPath}sun$_svg';

  static const rainy = '${_svgWeatherIconPath}rainyWeather$_svg';
  static const wind_speed = '${_svgWeatherIconPath}wind_speed$_svg';
  static const eye = '${_svgWeatherIconPath}eye$_svg';
  static const danger = '${_svgWeatherIconPath}danger$_svg';

  static const weatherDay = 'assets/icons/svg/weather/day/';
  static const weatherNight = 'assets/icons/svg/weather/night/';

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

//! Appointment
  static const calendarIcon = '${_svgIconPath}calendar_icon$_svg';

  //! Quran
  static const quranBookMarkIcon = '${_svgIconPath}quran_bookmark_go$_svg';
  static const quranChangePageIcon = '${_svgIconPath}quran_change_page$_svg';
  static const quranJozzIcon = '${_svgIconPath}quran_jozz$_svg';
  static const quranMenuIcon = '${_svgIconPath}quran_menu$_svg';
  static const quranPrayIcon = '${_svgIconPath}quran_pray$_svg';
  static const quranSaveIcon = '${_svgIconPath}quran_save$_svg';
  static const quranSearchIcon = '${_svgIconPath}quran_search$_svg';
  static const quranMarkIcon = '${_svgIconPath}quran_mark$_svg';
  static const quranMainMarkIcon = '${_svgIconPath}quran_main_bookmark$_svg';

  // CR
  static const additionalActivity = '${_svgCRIconPath}additional_activity$_svg';
  static const undertaking = '${_svgCRIconPath}undertaking$_svg';
  static const clipboard = '${_svgCRIconPath}clipboard$_svg';
  static const building = '${_svgCRIconPath}building$_svg';
  static const shopData = '${_svgCRIconPath}shop_data$_svg';
  static const warning2 = '${_svgCRIconPath}warning_2$_svg';
  static const boxTick = '${_svgCRIconPath}box_tick$_svg';

  // Wallet
  static const personalCard = '${_svgWalletIconPath}personal_card$_svg';
  static const card = '${_svgWalletIconPath}card$_svg';
  static const sliderVertical = '${_svgWalletIconPath}slider_vertical$_svg';
  static const shoppingBag = '${_svgWalletIconPath}shopping_bag$_svg';
  static const buildingIcon = '${_svgIconPath}building$_svg';

  //Map
  static const investmentIcon = '${_svgIconPath}invetment_icon$_svg';
  static const mapLocationIcon = '${_svgIconPath}map_location_icon$_svg';

  // Building Requirements
  static const checked = '${_svgIconPath}checked$_svg';
  static const taskSquare1 = '${_svgIconPath}task_square$_svg';
  static const taskSquare2 = '${_svgIconPath}task_square2$_svg';
  static const taskSquare3 = '${_svgIconPath}task_square3$_svg';
  //Athkar

  static const morningAthkarIcon = '${_svgAthkarIconPath}morning_athkar$_svg';
  static const sleepingAthkarIcon = '${_svgAthkarIconPath}evening_athkar$_svg';
  static const eveningAthkarIcon = '${_svgAthkarIconPath}sleeping_athkar$_svg';
  static const reset = '${_svgAthkarIconPath}reset$_svg';

  static const muslimNumberFrame =
      '${_svgAthkarIconPath}muslim_number_frame$_svg';

  static const boardingSplashLogo = '${_boardingLogoPath}balady_logo$_svg';
  //etmam app
}
