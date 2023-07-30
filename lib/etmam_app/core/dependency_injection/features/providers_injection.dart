import '../dependency_injection_exports.dart' show sl;
import '../../../features/providers/providers_exports.dart'
    show
        GetProvider,
        GetProviderDetails,
        ProvidersCacheDataSource,
        ProvidersCacheDataSourceImpl,
        ProvidersRemoteDataSource,
        ProvidersRemoteDataSourceImpl,
        ProvidersLocalDataSource,
        ProvidersRepository,
        ProvidersLocalDataSourceImpl,
        ProvidersRepositoryImpl;

class ProvidersInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetProvider(repository: sl()));
    sl.registerLazySingleton(() => GetProviderDetails(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<ProvidersRepository>(
      () => ProvidersRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), cacheDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<ProvidersRemoteDataSource>(
      () => ProvidersRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<ProvidersLocalDataSource>(
      () => ProvidersLocalDataSourceImpl(),
    );

    sl.registerLazySingleton<ProvidersCacheDataSource>(
      () => ProvidersCacheDataSourceImpl(),
    );
  }
}
