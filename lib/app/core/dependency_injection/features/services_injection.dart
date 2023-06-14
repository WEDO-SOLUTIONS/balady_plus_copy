import 'package:balady_plus/app/features/services/services_exports.dart'
    show
        ImportantServices,
        MunicipalServices,
        NewServices,
        PublicServices,
        ServicesLocalDataSource,
        ServicesLocalDataSourceImplementation,
        ServicesRepository,
        ServicesRepositoryImplementation;

import '../dependency_injection_exports.dart' show sl;

class ServicesInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => PublicServices(sl()));
    sl.registerLazySingleton(() => MunicipalServices(sl()));
    sl.registerLazySingleton(() => NewServices(sl()));
    sl.registerLazySingleton(() => ImportantServices(sl()));

    //! Repository
    sl.registerLazySingleton<ServicesRepository>(
      () => ServicesRepositoryImplementation(localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<ServicesLocalDataSource>(
      () => ServicesLocalDataSourceImplementation(),
    );
  }
}
