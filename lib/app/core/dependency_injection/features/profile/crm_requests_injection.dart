import '../../../../features/profile_features/incidents/requests_exports.dart'
    show
        RequestsRemoteDataSource,
        RequestsRemoteDataSourceImplementation,
        RequestsRepository,
        RequestsRepositoryImplementation;
import '../../dependency_injection_exports.dart' show sl;

class CRMRequestsInjection {
  static void init() {
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
  }
}
