import 'package:balady_plus/app/features/services/services_exports.dart'
    show
        BusinessLicenseServices,
        CustomerVoiceServices,
        HealthCertificatesServices,
        HelpServices,
        HonoringTheDeadServices,
        ImportantServices,
        IslamicServices,
        NewServices,
        ServicesLocalDataSource,
        ServicesLocalDataSourceImplementation,
        ServicesRepository,
        ServicesRepositoryImplementation;

import '../dependency_injection_exports.dart' show sl;

class ServicesInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => CustomerVoiceServices(sl()));
    sl.registerLazySingleton(() => IslamicServices(sl()));
    sl.registerLazySingleton(() => BusinessLicenseServices(sl()));
    sl.registerLazySingleton(() => HelpServices(sl()));
    sl.registerLazySingleton(() => HonoringTheDeadServices(sl()));
    sl.registerLazySingleton(() => HealthCertificatesServices(sl()));

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
