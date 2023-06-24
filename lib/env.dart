import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:flutter/material.dart'
    show BoxShadow, Color, Colors, WidgetsFlutterBinding;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizationDefaultType, translator;
import './app/core/dependency_injection/dependency_injection_exports.dart' as di
    show initialize;

import './app/core/services/services_exports.dart' show HiveManager;
import './app/core/utils/utils_exports.dart'
    show AppConfig, CommonFunctions, EnvType;
import './app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'app/core/services/local/initializer.dart';

abstract class AppEnv {
  static Future<void> setupEnv(EnvType type) async {
    WidgetsFlutterBinding.ensureInitialized();

    /// force app to be only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    sharedPrefs.init();
    // di: dependency injection
    di.initialize();

    //! Please assign environment firstly
    sl.registerLazySingleton<EnvType>(() => type);

    // Get available cameras
    //final cameras = await CommonFunctions.getAvailableCameras();

    // initialize somethings before start app, e.g. device details, lang
    await Initializer.init();

    // Initialize hive and open all needed boxes
    await HiveManager.initializeHive();

    await translator.init(
      // localeType: LocalizationDefaultType.device, // based on device language
      // localeType: LocalizationDefaultType.asDefined, // based on first element at languageList
      localeType: LocalizationDefaultType.asDefined,
      languagesList: AppConfig.defaultAppLanguage.languages,
      assetsDirectory: AppConfig.appLanguagesPath,
    );
    configLoading();
  }

  static void configLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..boxShadow = <BoxShadow>[]
      ..textColor = Colors.white
      ..indicatorColor = const Color(0xff389492)
      ..maskType = EasyLoadingMaskType.clear
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
