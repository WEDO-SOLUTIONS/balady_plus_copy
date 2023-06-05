import '../../../features/entry_point/entry_point_exports.dart'
    show
        ClearAuth,
        EntryPointLocalDataSource,
        EntryPointLocalDataSourceImplementation,
        EntryPointParams,
        EntryPointRepository,
        EntryPointRepositoryImplementation,
        FetchAuth,
        PersistAuth,
        UpdateAuth;
import '../dependency_injection_exports.dart' show sl;

class EntryPointInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => ClearAuth(repository: sl()));
    sl.registerLazySingleton(() => FetchAuth(repository: sl()));
    sl.registerLazySingleton(() => PersistAuth(repository: sl()));
    sl.registerLazySingleton(() => UpdateAuth(repository: sl()));

    //! Entities
    sl.registerLazySingleton(() => const EntryPointParams());

    //! Repository
    sl.registerLazySingleton<EntryPointRepository>(
      () => EntryPointRepositoryImplementation(localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<EntryPointLocalDataSource>(
      () => EntryPointLocalDataSourceImplementation(secureStorage: sl()),
    );
  }
}
