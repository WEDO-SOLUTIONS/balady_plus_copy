import '/app/features/map/data/data_sources/remote_data_source.dart';
import '/app/features/map/data/repositories/repository_implementation.dart';
import '/app/features/map/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class MapInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<SmartAdvisorMapRepository>(
      () => SmartAdvisorMapRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<SmartAdvisorMapRemoteDataSource>(
      () => SmartAdvisorMapRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
