import '../../../features/lookup/lookup_exports.dart'
    show
        GetLookup,
        LookupParams,
        LookupRemoteDataSource,
        LookupRemoteDataSourceImplementation,
        LookupRepository,
        LookupRepositoryImplementation;
import '../dependency_injection_exports.dart' show sl;

class LookupInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetLookup(repository: sl()));

    //! Entities
    sl.registerLazySingleton(() => const LookupParams());

    //! Repository
    sl.registerLazySingleton<LookupRepository>(
      () => LookupRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<LookupRemoteDataSource>(
      () => LookupRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
