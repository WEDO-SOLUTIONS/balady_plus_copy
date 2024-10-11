/*//import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizationDefaultType, LocalizedApp, translator;
import './app/core/dependency_injection/dependency_injection_exports.dart' as di
    show initialize;

import './app/core/se§rvices/services_exports.dart' show SimpleBlocObserver;
import './app/core/utils/utils_exports.dart' show AppConfig, EnvType;
import './app/app.dart';
import './app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setupMapness();

  /// force app to be only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // di: dependency injection
  di.initialize();

  //! Please assign environment firstly
  sl.registerLazySingleton<EnvType>(() => EnvType.dev);
  //
  // // Initialize hive and open all needed boxes
  // await HiveManager.initializeHive();

  await translator.init(
    // localeType: LocalizationDefaultType.device, // based on device language
    // localeType: LocalizationDefaultType.asDefined, // based on first element at languageList
    localeType: LocalizationDefaultType.asDefined,
    languagesList: AppConfig.defaultAppLanguage.languages,
    assetsDirectory: AppConfig.appLanguagesPath,
  );

  //! comment it in release mode
  // to observe all blocs movements
  if (sl<EnvType>().isDev) Bloc.observer = SimpleBlocObserver();

  runApp(LocalizedApp(child: const App()));
}
*/
/*Future<void> setupMapness() async {
  const vendorConfig = VendorConfigMessage.momrahProd;

  await initialiseDGis(
    logOptions: LogOptionsMessage(
      systemLevel: LogLevelMessage.fatal,
      customLevel: LogLevelMessage.fatal,
    ),
    config: vendorConfig,
  );
}*/
