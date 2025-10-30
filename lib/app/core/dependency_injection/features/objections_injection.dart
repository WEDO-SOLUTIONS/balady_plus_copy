import '../../../features/objections/objections_exports.dart'
    show
        RequestsRemoteDataSource,
        RequestsRemoteDataSourceImplementation,
        RequestsRepository,
        RequestsRepositoryImplementation;
import '../dependency_injection_exports.dart' show sl;

class ObjectionsInjection {
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
      ),
    );
  }
}
