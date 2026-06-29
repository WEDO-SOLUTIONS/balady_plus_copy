import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show BoxShadow, Color, Colors, WidgetsFlutterBinding;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hijri/hijri_calendar.dart' show HijriCalendar;
import 'package:localize_and_translate/localize_and_translate.dart' show LocalizationDefaultType, translator;

import './app/core/dependency_injection/dependency_injection_exports.dart'
    as di
    show initialize;
import './app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import './app/core/services/services_exports.dart'
    show HiveManager, NotificationService;
import './app/core/dependency_injection/dependency_injection_exports.dart'
    as di
    show initialize;
import './app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import './app/core/utils/utils_exports.dart'
    show AppConfig, CommonFunctions, EnvType;
import 'app/core/services/local/initializer.dart';
import 'app/core/services/local/notification_hawaii.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppEnv {
  static Future<void> setupEnv(EnvType type) async {
    ///  await _deleteAppDir();
    // await _deleteCacheDir();

    sl.registerLazySingleton<EnvType>(() => type);

    WidgetsFlutterBinding.ensureInitialized();
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    AdjustConfig config = AdjustConfig(
      await CommonFunctions.isHuaweiDevice() ? 'je5w29fx8y68' : 'tung4x27vt34',
      (type == EnvType.prod)
          ? AdjustEnvironment.production
          : AdjustEnvironment.sandbox,
    );

    config.logLevel = AdjustLogLevel.verbose;

    config.fbAppId = "1668346683733303";
    if (Platform.isIOS) {
      if (status == TrackingStatus.authorized) {
        Adjust.initSdk(config);
      }
    } else {
      Adjust.initSdk(config);
    }
    if (Platform.isAndroid) {
      Adjust.getGoogleAdId().then((googleAdId) {
        if (kDebugMode) {
          print(googleAdId);
        }
        // Use googleAdId string value.
      });
    }

    /// force app to be only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      //TODO: enable landscape mode after testing
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);

    //MapUtils.loadMarkers();

    sharedPrefs.init();
    // di: dependency injection
    di.initialize();
    //! Please assign environment firstly

    String testName = ".env.${type.name}";
    // Load the local files by the type.name (stg) send from main
    try {
      await dotenv.load(fileName: testName); // Load .env for local development
    } catch (_) {
      // if cant load the files get the variables from pipelines
    }
    // Get available cameras
    //final cameras = await CommonFunctions.getAvailableCameras();

    // initialize somethings before start app, e.g. device details, lang

    // Initialize hive and open all needed boxes
    await HiveManager.initializeHive();

    await translator.init(
      // localeType: LocalizationDefaultType.device, // based on device language
      // localeType: LocalizationDefaultType.asDefined, // based on first element at languageList
      localeType: LocalizationDefaultType.device,
      languagesList: AppConfig.defaultAppLanguage.languages,
      assetsDirectory: AppConfig.appLanguagesPath,
    );

    if (Platform.isAndroid && type == EnvType.dev) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    const hijriSupportedLocales = {'en', 'ar', 'tr'};
    final hijriLocale = hijriSupportedLocales.contains(translator.activeLanguageCode)
        ? translator.activeLanguageCode
        : 'en';
    HijriCalendar.setLocal(hijriLocale);
    configLoading();
    await Initializer.init();
    NotificationService.init(initScheduled: true);

    FlutterHmsGmsAvailability.isGmsAvailable.then((isAvailable) async {
      if (isAvailable) {
        await NotificationService.configure();
      }
    });
    FlutterHmsGmsAvailability.isHmsAvailable.then((isAvailable) async {
      if (isAvailable) {
        await HawaiiNotificationService().configure();
      }
    });
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
