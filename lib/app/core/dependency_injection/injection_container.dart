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
import '../../features/location/presentation/bloc/location_bloc.dart';
import '../../features/map_page/data/repositories/layers_repositories.dart';
import '../../features/weather/weather_exports.dart';
import '../dependency_injection/dependency_injection_exports.dart'
    show
        DashboardInjection,
        DelegatorsInjection,
        EntryPointInjection,
        InvoicesInjection,
        LicensesInjection,
        OTPInjection,
        PrayerTimesInjection,
        RequestsInjection,
        ServicesInjection,
        SignUpInjection,
        OLDInjection;
import '../services/global/web_service_weather.dart';
import '../services/services_exports.dart'
    show
        EntryPointBridge,
        NetworkConnection,
        NetworkConnectionImplementation,
        WebService;
import 'features/events_injection.dart';
import 'features/services/public_services/prayer_times_injection.dart';
import 'features/vd_injection.dart';

/// sl -> Service Locator
final sl = GetIt.instance;

void initialize() {
  OLDInjection.init();
  //! Features
  //? Entry Point
  EntryPointInjection.init();
  //? OTP
  OTPInjection.init();
  //? Sign-Up
  SignUpInjection.init();
  //? Services
  ServicesInjection.init();
  PrayerTimesInjection.init();

  EventsInjection.init();

  VDInjection.init();
  //! Services
  //* Public Services

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
  sl.registerLazySingleton(() => LocationCubit());
  sl.registerLazySingleton(() => const PackageDetails());
  //! External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LayersRepositories(webService: sl()));

  sl.registerLazySingleton(() => WebServiceWeather(dio: Dio()));

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
      webServiceWeather: sl(),
    ),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(),
  );
}
