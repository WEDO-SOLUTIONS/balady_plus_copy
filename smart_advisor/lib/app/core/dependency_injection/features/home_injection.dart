import '../../../features/home_page/data/data_sources/remote_data_source.dart';
import '../../../features/home_page/data/repositories/repository_implementation.dart';
import '../../../features/home_page/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class HomeInjection {
  static void init() {
    //! Repository
    sl.registerFactory<SmartAdvisorHomeRepository>(
      () => SmartAdvisorHomeRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerFactory<SmartAdvisorHomeRemoteDataSource>(
      () => SmartAdvisorHomeRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
