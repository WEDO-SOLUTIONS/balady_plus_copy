import 'package:balady_plus/app/features/profile_features/violations/violations_exports.dart';
import '../../dependency_injection_exports.dart' show sl;

class ViolationsInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetViolations(repository: sl()));
    sl.registerLazySingleton(() => GetViolationsStatuses(repository: sl()));
    sl.registerLazySingleton(() => GetInvoiceStatuses(repository: sl()));

    //! Repository
    sl.registerLazySingleton<ViolationsRepository>(
      () => ViolationsRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<ViolationsRemoteDataSource>(
      () => ViolationsRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
