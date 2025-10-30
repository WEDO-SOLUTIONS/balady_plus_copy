import '../dependency_injection_exports.dart' show sl;
import '../../../features/services/services_exports.dart'
    show
        GetServicesProvidersByService,
        ServicesCacheDataSource,
        ServicesCacheDataSourceImpl,
        ServicesRemoteDataSource,
        ServicesRemoteDataSourceImpl,
        ServicesLocalDataSource,
        ServicesRepository,
        ServicesLocalDataSourceImpl,
        ServicesRepositoryImpl,
        GetServiceDetails,
        GetReleation;

class ServiceInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(
        () => GetServicesProvidersByService(repository: sl()));
    sl.registerLazySingleton(() => GetServiceDetails(repository: sl()));
    sl.registerLazySingleton(() => GetReleation(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<ServicesRepository>(
      () => ServicesRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), cacheDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<ServicesRemoteDataSource>(
      () => ServicesRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<ServicesLocalDataSource>(
      () => ServicesLocalDataSourceImpl(),
    );

    sl.registerLazySingleton<ServicesCacheDataSource>(
      () => ServicesCacheDataSourceImpl(),
    );
  }
}
