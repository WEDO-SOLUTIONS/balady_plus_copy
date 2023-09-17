import 'package:balady_plus/etmam_app/core/services/remote/notification_service.dart';
import 'package:balady_plus/etmam_app/core/utils/initializers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;
import '../../features/_shared_feature_/shared/shared_feature_exports.dart'
    show NavBarInfo;
import '../dependency_injection/dependency_injection_exports.dart'
    show
        SearchInjection,
        HomeInjection,
        AuthInjection,
        CityInjection,
        MyOrdersInjection,
        ServiceInjection,
        ProvidersInjection,
        OTPInjection,
        SubmitRequestInjection;
import '../services/services_exports.dart'
    show NetworkConnection, NetworkConnectionImplementation, WebService;
import 'features/dynamic_form_injection.dart';

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
