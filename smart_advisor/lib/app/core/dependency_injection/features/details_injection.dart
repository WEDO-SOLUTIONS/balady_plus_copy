import '/app/features/details/data/data_sources/remote_data_source.dart';
import '/app/features/details/data/repositories/repository_implementation.dart';
import '/app/features/details/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class DetailsInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<DetailsRepository>(
      () => DetailsRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<DetailsRemoteDataSource>(
      () => DetailsRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
