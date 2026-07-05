import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;

import '../utils_exports.dart' show AppLanguage;

class AppConfig {
  // get current language code of app
  static final languageCode = translator.activeLanguageCode;
  static const AppLanguage defaultAppLanguage = AppLanguage.ar;
  static const String appLanguagesPath = 'assets/langs/';
  static const String appFontPath = 'assets/fonts/';

  static const String arabicUIFontType = 'packages/balady_design_system/IBMPlexSansArabic';
  static const String cairoFontType = 'Cairo';
  static const String appFontType = arabicUIFontType;

  static const String defaultCountryCode = '+966';

  static const List<String> fileExtensions = [
    "pdf",
    "png",
    "jpg",
    "tiff",
    "gif"
  ];
}
