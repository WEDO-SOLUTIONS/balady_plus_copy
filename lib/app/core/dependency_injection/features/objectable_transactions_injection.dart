import '../../../features/objectable_transactions/objections_exports.dart'
    show
        RequestsRemoteDataSource,
        RequestsRemoteDataSourceImplementation,
        RequestsRepository,
        RequestsRepositoryImplementation;
import '../dependency_injection_exports.dart' show sl;

class ObjectableTransactionsInjection {
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
