import 'package:balady_plus/etmam_app/features/submit_request/domain/use_cases/submit_request.dart';

import '../dependency_injection_exports.dart' show sl;
import '../../../features/submit_request/submit_request_exports.dart'
    show
        SubmitRequestLocalDataSource,
        SubmitRequestRemoteDataSource,
        SubmitRequestRemoteDataSourceImpl,
        SubmitRequestRepository,
        SubmitRequestLocalDataSourceImpl,
        SubmitRequestRepositoryImpl;

class SubmitRequestInjection {
  static void init() {
    sl.registerLazySingleton(() => SubmitRequest(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<SubmitRequestRepository>(
      () => SubmitRequestRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<SubmitRequestRemoteDataSource>(
      () => SubmitRequestRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<SubmitRequestLocalDataSource>(
      () => SubmitRequestLocalDataSourceImpl(),
    );
  }
}
