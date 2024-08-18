import '../features/pemrit_24_hour/data/data_sources/remote_data_source.dart';
import '../features/pemrit_24_hour/data/repositories/repository_implementation.dart';
import '../features/pemrit_24_hour/domain/repositores/repository.dart';
import '../../core/dependency_injection/dependency_injection_exports.dart' show sl;

class CommercialsPermits24Injection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<Permits24Repository>(
      () => Permits24RepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<Permits24RemoteDataSource>(
      () => Permits24RemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
