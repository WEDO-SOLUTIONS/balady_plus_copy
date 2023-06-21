import '../../../../features/profile_features/licenses/licenses_exports.dart'
    show
        GetLicenseStatuses,
        GetLicenseSubTypes,
        GetLicenseTypes,
        GetLicenses,
        LicensesBloc,
        LicensesRemoteDataSource,
        LicensesRemoteDataSourceImplementation,
        LicensesRepository,
        LicensesRepositoryImplementation;
import '../../dependency_injection_exports.dart' show sl;

class LicensesInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetLicenses(repository: sl()));
    sl.registerLazySingleton(() => GetLicenseStatuses(repository: sl()));
    sl.registerLazySingleton(() => GetLicenseTypes(repository: sl()));
    sl.registerLazySingleton(() => GetLicenseSubTypes(repository: sl()));

    //! Repository
    sl.registerLazySingleton<LicensesRepository>(
      () => LicensesRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<LicensesRemoteDataSource>(
      () => LicensesRemoteDataSourceImplementation(
        webService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => LicensesBloc(
        getLicenses: sl(),
        getLicenseStatuses: sl(),
        getMunicipalities: sl(),
        getSubMunicipalities: sl(),
        getLicenseTypes: sl(),
      ),
    );
  }
}
