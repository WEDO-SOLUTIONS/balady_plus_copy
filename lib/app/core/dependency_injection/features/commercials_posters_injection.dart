import '../../../features/posters/data/data_sources/remote_data_source.dart';
import '../../../features/posters/data/repositories/repository_implementation.dart';
import '../../../features/posters/domain/repositores/repository.dart';
import '../../../features/report_damaged_car/damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSourceImpl,
        DCRepositoryImpl,
        DCRemoteDataSource;

import '../dependency_injection_exports.dart' show sl;

class CommercialsPostersInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<PostersRepository>(
      () => PostersRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<PostersRemoteDataSource>(
      () => PostersRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
