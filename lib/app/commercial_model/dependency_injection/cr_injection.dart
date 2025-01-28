import '../features/commercial_license/commercial_license_exports.dart';
import '../../core/dependency_injection/dependency_injection_exports.dart' show sl;

class CrInjection {
  static void init() {
    sl.registerLazySingleton(() => CommercialLicenseBloc());

    //! Repository
    sl.registerLazySingleton<CrRepository>(
      () => CrRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<CrRemoteDataSource>(
      () => CrRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
