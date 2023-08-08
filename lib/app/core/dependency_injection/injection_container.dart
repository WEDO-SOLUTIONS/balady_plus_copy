import 'package:balady_plus/app/core/dependency_injection/features/old_injection.dart';
import 'package:balady_plus/app/core/dependency_injection/features/dc_injection.dart';
import 'package:balady_plus/app/core/dependency_injection/features/profile/crm_requests_injection.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show
        WeatherRepository,
        WeatherRepositoryImpl,
        WeatherRemoteDataSource,
        WeatherRemoteDataSourceImpl,
        WeatherLocalDataSource,
        WeatherLocalDataSourceImpl,
        GetWeatherInfo,
        GetWeatherInfoImpl,
        WeatherBloc,
        WeatherState,
        GetWeatherForLocation,
        BlocStatus,
        ServerFailure,
        WeatherParams,
        AllWeatherInfoEntity;
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
import '../../features/map_page/data/repositories/layers_repositories.dart';
import '../../features/weather/presentation/bloc/weather_bloc.dart';
import '../dependency_injection/dependency_injection_exports.dart'
    show
        CrInjection,
        DashboardInjection,
        DelegatorsInjection,
        EntryPointInjection,
        InvoicesInjection,
        LicensesInjection,
        MunicipalAdvisorInjection,
        OTPInjection,
        PrayerTimesInjection,
        RequestsInjection,
        ServicesInjection,
        SignUpInjection,
        VDInjection,
        ViolationsInjection;
import '../services/global/crm_web_service.dart';
import '../services/services_exports.dart'
    show
        EntryPointBridge,
        NetworkConnection,
        NetworkConnectionImplementation,
        WebService;
import 'features/dc_injection.dart';
import 'features/objectable_transactions_injection.dart';
import 'features/objections_injection.dart';
import 'features/retrive_dc_injection.dart';

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize() {
  OLDInjection.init();
  //! Features
  //? Entry Point
  EntryPointInjection.init();
  //? OTP
  OTPInjection.init();
  ;
  //? Sign-Up
  SignUpInjection.init();
  //? Services
  ServicesInjection.init();

  //! Services
  //* Public Services
  //? Prayer Times
  PrayerTimesInjection.init();
  //* Municipal Services
  //? Municipal Advisor
  MunicipalAdvisorInjection.init();
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
  //? Violations
  ViolationsInjection.init();

//? Objections
  ObjectionsInjection.init();
//? Objectable Transactions
  ObjectableTransactionsInjection.init();

//? DC
  DCInjection.init();
  DCRetriveInjection.init();

  CRMRequestsInjection.init();
//? Cr
  CrInjection.init();

  //! Core
  sl.registerLazySingleton(() => WebService(dio: sl()));
  sl.registerLazySingleton(() => CRMWebService(dio: Dio()));

// Weather
  //Blocs
  sl.registerLazySingleton(() => WeatherBloc(getWeatherInfo: sl()));
  //Domain
  //UseCases
  sl.registerLazySingleton(() => GetWeatherInfo(repository: sl()));
  //Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  //DataSources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      webService: sl(),
    ),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(),
  );

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

  sl.registerLazySingleton(() => LayersRepositories(webService: sl()));
}
