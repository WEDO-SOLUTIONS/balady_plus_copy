import '../../../features/report_damaged_car/damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSourceImpl,
        DCRepositoryImpl,
        DCRemoteDataSource;
import '../../../features/retrive_car/data/data_sources/dc_remote_data_source.dart';
import '../../../features/retrive_car/data/repositories/dc_repository_impl.dart';
import '../../../features/retrive_car/domain/repositories/dc_repository.dart';
import '../dependency_injection_exports.dart' show sl;

class DCRetriveInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<DCRetriveRepository>(
      () => DCRetriveRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<DCRetriveRemoteDataSource>(
      () => DCRetriveRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
