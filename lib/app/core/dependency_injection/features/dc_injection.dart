import '../../../features/report_damaged_car/damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSourceImpl,
        DCRepositoryImpl,
        DCRemoteDataSource;
import '../dependency_injection_exports.dart' show sl;

class DCInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<DCRepository>(
      () => DCRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<DCRemoteDataSource>(
      () => DCRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
