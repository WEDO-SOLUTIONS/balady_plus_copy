import '../../../../features/profile_features/delegators/delegators_exports.dart'
    show
        DelegatorsCubit,
        DelegatorsRemoteDataSource,
        DelegatorsRemoteDataSourceImplementation,
        DelegatorsRepository,
        DelegatorsRepositoryImplementation,
        GetAgents,
        GetDelegators;

import '../../dependency_injection_exports.dart' show sl;

class DelegatorsInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetDelegators(sl()));
    sl.registerLazySingleton(() => GetAgents(sl()));

    //! Repository
    sl.registerLazySingleton<DelegatorsRepository>(
      () => DelegatorsRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<DelegatorsRemoteDataSource>(
      () => DelegatorsRemoteDataSourceImplementation(webService: sl()),
    );

    //! Cubit
    sl.registerLazySingleton(
      () => DelegatorsCubit(sl(), sl()),
    );
  }
}
