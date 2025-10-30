import 'package:get_it/get_it.dart' show GetIt;

import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/features/dynamic_form_injection.dart';
import 'package:balady_plus/etmam_app/core/utils/initializers.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart' show NavBarInfo;

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize() {
  //! Features

  //? City
  CityInjection.init();

  //? Entry Point
  AuthInjection.init();

  //? Search
  SearchInjection.init();

  //? Home
  HomeInjection.init();

  //? Services
  ServiceInjection.init();

  //? Providers
  ProvidersInjection.init();

  //? SubmitRequest
  SubmitRequestInjection.init();

  //? My Orders
  MyOrdersInjection.init();

  //? OTP
  OTPInjection.init();

  //? Auth
  //AuthInjection.init();
  DynamicFormsInjection.init();
  //? shared Prefs
  Initializers.loadData();

  //! Core
  //sl.registerLazySingleton(() => WebService(dio: sl()));
  //sl.registerLazySingleton<NetworkConnection>(
  //  () => NetworkConnectionImplementation(sl()),
  //);
  //sl.registerLazySingleton(() => NotificationsServices());

  //sl.registerLazySingleton(() => const BridgeParams());
  //sl.registerLazySingleton(() => const EntryPointBridge());
  sl.registerLazySingleton(() => const NavBarInfo());

  //! External
  //sl.registerLazySingleton(() => const FlutterSecureStorage());
  //sl.registerLazySingleton(() => InternetConnectionChecker());
  //sl.registerLazySingleton(() => Dio());
}
