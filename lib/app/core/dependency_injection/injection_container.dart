import 'package:balady_plus/app/commercial_model/dependency_injection/commercial_injection.dart';
import 'package:balady_plus/app/core/dependency_injection/features/old_injection.dart';
import 'package:balady_plus/app/core/dependency_injection/features/dc_injection.dart';
import 'package:balady_plus/app/core/dependency_injection/features/profile/crm_requests_injection.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/features/_shared_features/check_commercial_license/data/data_sources/check_commercial_license_data_source.dart';
import 'package:balady_plus/app/features/balady_calender/data/datasources/balady_calendar_data_source.dart';
import 'package:balady_plus/app/features/balady_calender/data/repositories/balady_calendar_repository.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart'
    as calendar;
import 'package:balady_plus/app/features/ceritified_observer/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/chatbot/data/data_sources/chat_bot_data_sources.dart';
import 'package:balady_plus/app/features/chatbot/data/repositories/chat_bot_repository_implementation.dart';
import 'package:balady_plus/app/features/chatbot/domain/repositories/chat_bot_repository.dart';
import 'package:balady_plus/app/features/chatbot/domain/use_cases/chat_bot_use_cases.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart'
    as events;
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_plus/app/features/services/core/dependency_injection/home_services_injection.dart';
import 'package:balady_plus/app/features/unknow/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show
        WeatherRepository,
        WeatherRepositoryImpl,
        WeatherRemoteDataSource,
        WeatherRemoteDataSourceImpl,
        WeatherLocalDataSource,
        WeatherLocalDataSourceImpl,
        GetWeatherInfo,
        WeatherBloc;
import 'package:dio/dio.dart' show Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;
import '../../features/_shared_feature_/balady_features/services/services.dart';
import '../../features/_shared_feature_/balady_features/widgets/UrbiMap/search_provider.dart';
import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/data/entities/package_details.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart'
    show BridgeParams, DropDownItem, FileInfo;
import '../../features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import '../../features/ceritified_observer/data/data_source/remote_data_source.dart';
import '../../features/ceritified_observer/domain/repository/repository.dart';
import '../../features/classification_certificate/core/dependency_injection/classification_certificate_injection.dart';
import '../../features/force_update/presentation/core/force_update_cubit.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';
import '../../features/map_page/data/repositories/layers_repositories.dart';
import '../../features/notifications/data/data_source/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_implementation.dart';
import '../../features/notifications/manager/notification_manager.dart';
import '../../features/qa/datasource/remote_data_source.dart';
import '../../features/unknow/data/repositories/repository_implementation.dart';
import '../../features/unknow/domain/repositories/repository.dart';
import '../../features/weather_alerts/presentation/bloc/weather_alerts_cubit.dart';
import '../dependency_injection/dependency_injection_exports.dart'
    show
        DashboardInjection,
        DelegatorsInjection,
        EntryPointInjection,
        InvoicesInjection,
        LicensesInjection,
        MunicipalAdvisorInjection,
        OTPInjection,
        PrayerTimesInjection,
        RequestsInjection,
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
import '../utils/enums/bottom_nav_bar.dart';
import 'features/calendar_injection.dart';
import 'features/compliance_injection.dart';
import 'features/ekram_injection.dart';
import 'features/events_injection.dart';
import 'features/objectable_transactions_injection.dart';
import 'features/objections_injection.dart';
import 'features/retrive_dc_injection.dart';
import 'features/violation_guide_injection.dart';
import 'features/weather_alerts_injection.dart';

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

  //? Violation Guide
  ViolationGuideInjection.init();

//? Objections
  ObjectionsInjection.init();
//? Objectable Transactions
  ObjectableTransactionsInjection.init();

//? DC
  DCInjection.init();
  DCRetriveInjection.init();

  CRMRequestsInjection.init();
//? Cr
//? Renew Commercial
  //?
  ComplianceInjection.init();

  EventsInjection.init();

  CalendarInjection.init();
  //? Ekram
  EkramInjection.init();

  //? Wather Alerts
  WeatherAlertsInjection.init();

  //! Core
  sl.registerLazySingleton(() => WebService(dio: sl()));
  // sl.registerLazySingleton(() => CRMWebService(dio: Dio()));
  sl.registerLazySingleton(
      () => BottomNavBarCubit(initialNavBar: BottomNavBar.home));

  sl.registerLazySingleton(() => WeatherAlertsCubit());

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
  sl.registerLazySingleton(() => LocationCubit());
  sl.registerLazySingleton(() => SplashCubit(splashRemoteDataSource: sl()));
  sl.registerLazySingleton(
    () => CalendarBloc()..add(const calendar.GetSearchEvent()),
  );
  sl.registerLazySingleton(
    () => EventsBloc()..add(const events.GetSearchEvent()),
  );

  //! External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => LayersRepositories(webService: sl()));
  sl.registerLazySingleton(() => BaladyServices(webService: sl()));

  sl.registerLazySingleton<InvestmentRepository>(
    () => InvestmentRepositoryImplementation(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<RequestsRemoteDataSource>(
    () => RequestsRemoteDataSourceImplementation(
      webService: sl(),
      // crmWebService: sl(),
    ),
  );

  sl.registerLazySingleton(() => ForceUpdateCubit());

  sl.registerLazySingleton<ChatBotDataSources>(
      () => ChatBotDataSourcesImplementation(webService: sl()));

  sl.registerLazySingleton<UrbiSearchProvider>(() => UrbiSearchProvider());

  sl.registerLazySingleton<ChatBotRepository>(
      () => ChatBotRepositoryImplementation(sl()));
  sl.registerLazySingleton(() => SendQuestionMessageChatBot(sl()));

  //  Balady Calendar
  sl.registerLazySingleton<BaladyCalendarRemoteDataSource>(
      () => CalendarBaladyRemoteDataSourceImpl(webService: sl()));
  sl.registerLazySingleton<BaladyCalendarRepository>(
      () => BaladyCalendarRepositoryImpl(remoteDataSource: sl()));
  /////////////// End
  //  Noification
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationRemoteDataSourceImplementation(webService: sl()));

  sl.registerLazySingleton<CheckCommercialLicenseDataSource>(
      () => CheckCommercialLicesnseDataSourceImpl(webService: sl()));

  sl.registerLazySingleton<NotificationRepositoryImplementation>(
      () => NotificationRepositoryImplementation(remoteDataSource: sl()));
  sl.registerLazySingleton<NotificationManager>(
      () => NotificationManager(repository: sl()));

  sl.registerLazySingleton<QuestionRemoteDataSourceImplementation>(() => QuestionRemoteDataSourceImplementation(webService: sl()));
  sl.registerLazySingleton<SplashRemoteDataSource>(() => SplashRemoteDataSourceImpl(webService: sl()));

  sl.registerLazySingleton<CertifiedObserverRemoteDataSource>(() => CertifiedObserverRemoteDataSourceImplementation(webService: sl()));
  sl.registerLazySingleton<CertifiedObserverRepository>(() => CertifiedObserverRepositoryImplementation(remoteDataSource: sl()));



  /////////////// End

  ///////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////
  /////////////// get All Commercial Injection Container
  CommercialInjectionContainer.init();
  /////////////// End
  /////////////// get All Classification Certificate Injection Container
  ClassificationCertificateInjectionContainer.init();
  /////////////// End
  /////////////// get All Home Services Certificate Injection Container
  HomeServicesInjectionContainer.init();
  /////////////// End



  /////////////// get All Authentication Model Injection Container
  switch (sl<EnvType>().name) {
    case "dev":
      slAuthentication.registerLazySingleton(
              () => BaladyAuthorizationEnvType.dev);
      break;
    case "stg":
      slAuthentication.registerLazySingleton(
              () => BaladyAuthorizationEnvType.stg);
      break;
    case "pre":
      slAuthentication.registerLazySingleton(
              () => BaladyAuthorizationEnvType.pre);
      break;
    case "prod":
      slAuthentication.registerLazySingleton(
              () => BaladyAuthorizationEnvType.prod);
    case "urbiPre":
      slAuthentication.registerLazySingleton(
              () => BaladyAuthorizationEnvType.urbiPre);
      break;
  }
  AuthenticationInjection.initialize();
  /////////////// End
}
