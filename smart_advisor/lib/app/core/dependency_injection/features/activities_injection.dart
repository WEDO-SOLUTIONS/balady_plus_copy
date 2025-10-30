import '/app/features/select_activity/domain/repositories/repository.dart';

import '../../../features/select_activity/data/data_sources/remote_data_source.dart';
import '../../../features/select_activity/data/repositories/repository_implementation.dart';
import '../dependency_injection_exports.dart' show sl;

class ActivitiesInjection {
  static void init() {
    //! Repository
    sl.registerFactory<ActivitesRepository>(
      () => ActivitesRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerFactory<ActivitesRemoteDataSource>(
      () => ActivitesRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
