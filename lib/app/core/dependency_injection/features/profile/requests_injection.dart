import '../../../../features/profile_features/requests/requests_exports.dart'
    show
        GetMunicipalities,
        GetRequestStatuses,
        GetRequestSubTypes,
        GetRequestTypes,
        GetRequests,
        GetSubMunicipalities,
        RequestsBloc,
        RequestsRemoteDataSource,
        RequestsRemoteDataSourceImplementation,
        RequestsRepository,
        RequestsRepositoryImplementation;
import '../../dependency_injection_exports.dart' show sl;

class RequestsInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetRequests(repository: sl()));
    sl.registerLazySingleton(() => GetRequestStatuses(repository: sl()));
    sl.registerLazySingleton(() => GetSubMunicipalities(repository: sl()));
    sl.registerLazySingleton(() => GetMunicipalities(repository: sl()));
    sl.registerLazySingleton(() => GetRequestTypes(repository: sl()));
    sl.registerLazySingleton(() => GetRequestSubTypes(repository: sl()));

    //! Repository
    sl.registerLazySingleton<RequestsRepository>(
      () => RequestsRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<RequestsRemoteDataSource>(
      () => RequestsRemoteDataSourceImplementation(
        webService: sl(),
        // crmWebService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => RequestsBloc(
        getRequests: sl(),
        getRequestStatuses: sl(),
        getMunicipalities: sl(),
        getSubMunicipalities: sl(),
        getRequestTypes: sl(),
        getRequestSubTypes: sl(),
      ),
    );
  }
}
