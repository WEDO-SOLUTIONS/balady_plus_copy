import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;

import '../utils_exports.dart' show AppLanguage;

class AppConfig {
  static final languageCode = translator.activeLanguageCode;
  static const AppLanguage defaultAppLanguage = AppLanguage.ar;
  static const String appLanguagesPath =
      'packages/smart_advisor/smart_advisor_assets/langs/';

  static String getCurrentLanguageCode() => translator.activeLanguageCode;

  static const String somarFontType = 'packages/balady_uikit/Frutiger';
  static const String appFontType = somarFontType;

  static Future changeLang(BuildContext context) {
    return translator.setNewLanguage(
      context,
      newLanguage: getCurrentLanguageCode() == "ar" ? 'en' : 'ar',
      remember: true,
      // restart: true,
    );
  }
}

String trans(String key) => key.tr();
