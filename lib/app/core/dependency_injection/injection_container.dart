import 'package:balady_plus/app/core/dependency_injection/features/dc_injection.dart';
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
        DelegatorsInjection,
        EntryPointInjection,
        InvoicesInjection,
        LicensesInjection,
        LookupInjection,
        OTPInjection,
        PrayerTimesInjection,
        RequestsInjection,
        ServicesInjection,
        SignInInjection,
        SignUpInjection,
        ObjectionsInjection,
        ObjectableTransactionsInjection,
        VDInjection,
        OLDInjection;
import '../services/services_exports.dart'
    show
        EntryPointBridge,
        NetworkConnection,
        NetworkConnectionImplementation,
        WebService;

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize() {
  OLDInjection.init();
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
//? Objections
  ObjectionsInjection.init();
//? Objectable Transactions
  ObjectableTransactionsInjection.init();

//? DC
  DCInjection.init();

  //! Services
  //* Public Services
  //? Prayer Times
  PrayerTimesInjection.init();
  //? VD
  VDInjection.init();

  //! Profile
  //? Delegators
  DelegatorsInjection.init();
  //? Dashboard
  DashboardInjection.init();
  //? Requests
  RequestsInjection.init();
  //? Invoices
  InvoicesInjection.init();
  //? Licenses
  LicensesInjection.init();

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
