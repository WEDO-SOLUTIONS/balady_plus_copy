import '../../../features/manage_license_flow/data/data_sources/remote_data_source.dart';
import '../../../features/manage_license_flow/data/repository/repository_implementation.dart';
import '../../../features/manage_license_flow/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class ManageLicenseInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<ManageLicenseRepository>(
      () => ManageLicenseImplementationRepository(licenseDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<ManageLicenseDataSource>(
      () => ManageLicenseDataSourceImplementation(webService: sl()),
    );
  }
}
