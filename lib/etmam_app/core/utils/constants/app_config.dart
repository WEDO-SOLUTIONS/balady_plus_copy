import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppLanguage;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;

class AppConfig {
  static final languageCode = translator.activeLanguageCode;
  static const AppLanguage defaultAppLanguage = AppLanguage.ar;
  static const String appLanguagesPath = 'assets/langs/';
  static const String appFontPath = 'assets/fonts/';

  static const String arabicUIFontType = 'packages/balady_uikit/Frutiger';
  //static const String cairoFontType = 'Cairo';
  static const String somarSans = 'SomarSans';
  static const String appFontType = arabicUIFontType;
}

String trans(String key) => key.tr();
