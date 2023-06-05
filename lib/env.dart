import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizationDefaultType, translator;
import './app/core/dependency_injection/dependency_injection_exports.dart' as di
    show initialize;

import './app/core/services/services_exports.dart' show HiveManager;
import './app/core/utils/utils_exports.dart' show AppConfig, EnvType;
import './app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

abstract class AppEnv {
  static Future<void> setupEnv(EnvType type) async {
    WidgetsFlutterBinding.ensureInitialized();

    /// force app to be only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // di: dependency injection
    di.initialize();

    //! Please assign environment firstly
    sl.registerLazySingleton<EnvType>(() => type);

    // Initialize hive and open all needed boxes
    await HiveManager.initializeHive();

    await translator.init(
      // localeType: LocalizationDefaultType.device, // based on device language
      // localeType: LocalizationDefaultType.asDefined, // based on first element at languageList
      localeType: LocalizationDefaultType.asDefined,
      languagesList: AppConfig.defaultAppLanguage.languages,
      assetsDirectory: AppConfig.appLanguagesPath,
    );
  }
}
