import 'package:balady_plus/app/core/dependency_injection/features/old_injection.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/features/_shared_features/check_commercial_license/data/data_sources/check_commercial_license_data_source.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart' as events;
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_plus/app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:balady_plus/app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:balady_plus/app/features/weather/data/repositories/weather_repository_imp.dart';
import 'package:balady_plus/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:balady_plus/app/features/weather/domain/usecases/get_weather_info.dart';
import 'package:balady_plus/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:balady_plus/mini_apps_engine/data/datasource/events_data_source.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/data_sources/new_mini_apps_logic_data_source.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/repositories/new_mini_apps_logic_repository_impl.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/repositories/new_mini_apps_logic_repository.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/use_cases/get_new_mini_apps_logic_usecase.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';

import 'package:dio/dio.dart' show Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' show FlutterSecureStorage;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart' show InternetConnection;
import '../../features/_shared_feature_/balady_features/services/services.dart';
import '../../features/_shared_feature_/balady_features/widgets/UrbiMap/search_provider.dart';
import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/data/entities/package_details.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart' show BridgeParams, DropDownItem, FileInfo;
import '../../features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';
import '../../features/notifications/data/data_source/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_implementation.dart';
import '../../features/notifications/manager/notification_manager.dart';
import '../../features/volunteer_profile/injection/volunteer_profile_injection.dart';
import '../dependency_injection/dependency_injection_exports.dart'
    show DelegatorsInjection, EntryPointInjection, OTPInjection, PrayerTimesInjection, SignUpInjection, VDInjection;
import '../services/services_exports.dart'
    show EntryPointBridge, NetworkConnection, NetworkConnectionImplementation, WebService;
import '../utils/enums/bottom_nav_bar.dart';
import 'features/profile/dashboard_injection.dart';

import 'package:balady_authorization/src/utils/injection/injection_container.dart';
import 'package:balady_authorization/src/web/global/remote_config.dart';

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

  //! Services
  //* Public Services
  //? Prayer Times
  PrayerTimesInjection.init();
  //* Municipal Services
  //? Municipal Advisor
  VDInjection.init();

  //! Profile
  //? Delegators
  DelegatorsInjection.init();
  //? Dashboard
  DashboardInjection.init();

  sl.registerLazySingleton<NetworkConnection>(() => NetworkConnectionImplementation(sl()));

  //! Core
  sl.registerLazySingleton(() => WebService(dio: sl()));
  // sl.registerLazySingleton(() => CRMWebService(dio: Dio()));
  sl.registerLazySingleton(() => BottomNavBarCubit(initialNavBar: BottomNavBar.home));

  // Weather
  //Blocs
  sl.registerLazySingleton(() => WeatherBloc(getWeatherInfo: sl()));
  //Domain
  //UseCases
  sl.registerLazySingleton(() => GetWeatherInfo(repository: sl()));
  //Repository
  sl.registerLazySingleton<WeatherRepository>(() => WeatherRepositoryImpl(sl(), sl()));
  //DataSources
  sl.registerLazySingleton<WeatherRemoteDataSource>(() => WeatherRemoteDataSourceImpl(webService: sl()));

  sl.registerLazySingleton<WeatherLocalDataSource>(() => WeatherLocalDataSourceImpl());

  sl.registerLazySingleton(() => const BridgeParams());
  sl.registerLazySingleton(() => const EntryPointBridge());
  sl.registerLazySingleton(() => const FileInfo());
  sl.registerLazySingleton(() => DropDownItem.emptyState());
  sl.registerLazySingleton(() => const DeviceDetails());
  sl.registerLazySingleton(() => const PackageDetails());
  sl.registerLazySingleton(() => LocationCubit());
  sl.registerLazySingleton(() => SplashCubit(splashRemoteDataSource: sl()));

  sl.registerLazySingleton(() => EventsBloc()..add(const events.GetSearchEvent()));

  //! External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => BaladyServices(webService: sl()));

  // sl.registerLazySingleton(() => ForceUpdateCubit());

  sl.registerLazySingleton<UrbiSearchProvider>(() => UrbiSearchProvider());

  /////////////// End
  //  Noification
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationRemoteDataSourceImplementation(webService: sl()),
  );

  sl.registerLazySingleton<CheckCommercialLicenseDataSource>(
    () => CheckCommercialLicesnseDataSourceImpl(webService: sl()),
  );

  sl.registerLazySingleton<NotificationRepositoryImplementation>(
    () => NotificationRepositoryImplementation(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationManager>(() => NotificationManager(repository: sl()));

  sl.registerLazySingleton<SplashRemoteDataSource>(() => SplashRemoteDataSourceImpl(webService: sl()));

  //// For Mini Apps Engine
  sl.registerLazySingleton<MiniAppsLocalDataSource>(
    () => MiniAppsDataSourceImplementation(webServices: sl<WebService>()),
  );
  sl.registerLazySingleton<MiniAppsRepository>(
    () => MiniAppsRepository(localDataSource: sl<MiniAppsLocalDataSource>()),
  );

  //! New mini apps logic ==========================================================

  //* Data Sources
  sl.registerLazySingleton<NewMiniAppsLogicDataSource>(
    () => NewMiniAppsLogicDataSourceImpl(webServices: sl<WebService>()),
  );

  //* Repository
  sl.registerLazySingleton<NewMiniAppsLogicRepository>(() => NewMiniAppsLogicRepositoryImpl(dataSource: sl()));

  //* Use Cases
  sl.registerLazySingleton(() => GetNewMiniAppsLogicUseCase(sl()));

  //* Cubits
  sl.registerLazySingleton<NewMiniAppLogicCubit>(
    () => NewMiniAppLogicCubit(sl<GetNewMiniAppsLogicUseCase>(), sl<FlutterSecureStorage>(), sl<MiniAppsRepository>()),
  );

  //! New mini apps logic ==========================================================

  /////////////// get All Authentication Model Injection Container
  switch (sl<EnvType>().name) {
    case "dev":
      slAuthentication.registerLazySingleton(() => BaladyAuthorizationEnvType.dev);
      break;
    case "stg":
      slAuthentication.registerLazySingleton(() => BaladyAuthorizationEnvType.stg);
      break;
    case "pre":
      slAuthentication.registerLazySingleton(() => BaladyAuthorizationEnvType.pre);
      break;
    case "prod":
      slAuthentication.registerLazySingleton(() => BaladyAuthorizationEnvType.prod);
    case "urbiPre":
      slAuthentication.registerLazySingleton(() => BaladyAuthorizationEnvType.urbiPre);
      break;
  }
  AuthenticationInjection.initialize();
  /////////////// End

  VolunteerProfileInjection.initialize();
}
