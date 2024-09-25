import '../features/pemrit_tobacco/data/data_sources/remote_data_source.dart';
import '../features/pemrit_tobacco/data/repositories/repository_implementation.dart';
import '../features/pemrit_tobacco/domain/repositores/repository.dart';
import '../../core/dependency_injection/dependency_injection_exports.dart' show sl;

class CommercialsTobaccoInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<PermitsTobaccoRepository>(
      () => PermitsTobaccoRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<PermitsTobaccoRemoteDataSource>(
      () => PermitsTobaccoRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
