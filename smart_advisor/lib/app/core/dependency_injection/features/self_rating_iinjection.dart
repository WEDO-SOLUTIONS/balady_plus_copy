import '../../../features/self_rating/data/data_sources/remote_data_source.dart';
import '../../../features/self_rating/data/repositories/repository_implementation.dart';
import '../../../features/self_rating/domain/repositories/repository.dart';
import '/app/features/fees_calculator/data/data_sources/remote_data_source.dart';
import '/app/features/fees_calculator/data/repositories/repository_implementation.dart';
import '/app/features/fees_calculator/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class SelfRatingInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<Repository>(
      () => RepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementation(webService: sl()),
    );
  }
}
