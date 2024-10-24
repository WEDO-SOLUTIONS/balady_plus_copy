import '../../../features/qr_scan/data/data_sources/remote_data_source.dart';
import '../../../features/qr_scan/data/repositories/repository_implementation.dart';
import '../../../features/qr_scan/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class QRInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<QRScanRepository>(
      () => QRScanRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<QrScanRemoteDataSource>(
      () => QrScanRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
