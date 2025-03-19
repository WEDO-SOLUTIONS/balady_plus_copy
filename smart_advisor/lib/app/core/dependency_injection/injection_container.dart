import 'package:smart_advisor/app/core/dependency_injection/features/qr_injection.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '../../features/details/domain/repositories/repository.dart';
import '../../features/fees_calculator/domain/repositories/repository.dart';
import '../../features/home_page/domain/repositories/repository.dart';
import '../../features/manage_license_flow/domain/repositories/repository.dart';
import '../../features/map/domain/repositories/repository.dart';
import '../../features/qr_scan/domain/repositories/repository.dart';
import '../../features/select_activity/domain/repositories/repository.dart';
import '../../features/self_rating/domain/repositories/repository.dart';
import '/app/core/dependency_injection/features/activities_injection.dart';
import '/app/core/dependency_injection/features/calculator_injection.dart';
import '/app/core/dependency_injection/features/details_injection.dart';
import '/app/core/dependency_injection/features/map_injection.dart';
import 'package:dio/dio.dart' show Dio;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'
//     show FlutterSecureStorage;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;

import '../dependency_injection/dependency_injection_exports.dart'
    show HomeInjection;
import '../services/services_exports.dart'
    show
        SharedPrefs,
        SmartAdvisorNetworkConnection,
        SmartAdvisorNetworkConnectionImplementation,
        SmartAdvisorWebService;
import 'features/manage_license_injection.dart';
import 'features/self_rating_iinjection.dart';

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize(EnvType env) {
  //! Features
  //? home

  SharedPrefs.init();

  if (!sl.isRegistered<SmartAdvisorHomeRepository>()) HomeInjection.init();

  //? Activities
  if (!sl.isRegistered<ActivitesRepository>()) ActivitiesInjection.init();

//? Details
  if (!sl.isRegistered<DetailsRepository>()) DetailsInjection.init();

  //? Map
  if (!sl.isRegistered<SmartAdvisorMapRepository>()) MapInjection.init();
  if (!sl.isRegistered<QRScanRepository>()) QRInjection.init();

//? Calculator
  if (!sl.isRegistered<CalculatorRepository>()) CalculatorInjection.init();

//? Calculator
  if (!sl.isRegistered<ManageLicenseRepository>())
    ManageLicenseInjection.init();

  if (!sl.isRegistered<Repository>()) SelfRatingInjection.init();
  //! Core
  if (!sl.isRegistered<SmartAdvisorWebService>())
    sl.registerLazySingleton(() => SmartAdvisorWebService(dio: new Dio()));

  if (!sl.isRegistered<SmartAdvisorNetworkConnection>())
    sl.registerLazySingleton<SmartAdvisorNetworkConnection>(
      () => SmartAdvisorNetworkConnectionImplementation(sl()),
    );

  if (!sl.isRegistered<InternetConnectionChecker>())
    sl.registerLazySingleton(() => InternetConnectionChecker());
  if (!sl.isRegistered<Dio>()) sl.registerLazySingleton(() => Dio());
  if (!sl.isRegistered<EnvType>()) sl.registerLazySingleton<EnvType>(() => env);
}
