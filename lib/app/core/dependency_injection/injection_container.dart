import 'package:dio/dio.dart' show Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;

import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/data/entities/package_details.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart'
    show BridgeParams, DropDownItem, FileInfo;
import '../dependency_injection/dependency_injection_exports.dart'
    show
        DashboardInjection,
        EntryPointInjection,
        LookupInjection,
        OTPInjection,
        RequestsInjection,
        ServicesInjection,
        SignInInjection,
        SignUpInjection;
import '../services/services_exports.dart'
    show
        EntryPointBridge,
        NetworkConnection,
        NetworkConnectionImplementation,
        WebService;

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize() {
  //! Features
  //? Entry Point
  EntryPointInjection.init();
  //? Lookup
  LookupInjection.init();
  //? OTP
  OTPInjection.init();
  //? Sign-In
  SignInInjection.init();
  //? Sign-Up
  SignUpInjection.init();
  //? Services
  ServicesInjection.init();

  //! Profile
  //? Dashboard
  DashboardInjection.init();
  //? Requests
  RequestsInjection.init();

  //! Core
  sl.registerLazySingleton(() => WebService(dio: sl()));
  sl.registerLazySingleton<NetworkConnection>(
    () => NetworkConnectionImplementation(sl()),
  );
  sl.registerLazySingleton(() => const BridgeParams());
  sl.registerLazySingleton(() => const EntryPointBridge());
  sl.registerLazySingleton(() => const FileInfo());
  sl.registerLazySingleton(() => DropDownItem.emptyState());
  sl.registerLazySingleton(() => const DeviceDetails());
  sl.registerLazySingleton(() => const PackageDetails());
  //! External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
