import '../../../../../features/municipal_services/municipal_advisor/municipal_advisor_exports.dart'
    show GetAccommodationTypes, GetActivityDetails, GetCivilDefensePredefinedConditions, GetCleaningMechanisms, GetCommercialOffices, GetConsultationKey, GetIsicActivities, GetIsicSubActivities, GetIssuingPredefinedConditions, GetLicensePermits, GetSupervisingAuthorities, MunicipalAdvisorBloc, MunicipalAdvisorRemoteDataSource, MunicipalAdvisorRemoteDataSourceImplementation, MunicipalAdvisorRepository, MunicipalAdvisorRepositoryImplementation, SaveConsultationProgress;
import '../../../dependency_injection_exports.dart' show sl;

class MunicipalAdvisorInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetIsicActivities(sl()));
    sl.registerLazySingleton(() => GetIsicSubActivities(sl()));
    sl.registerLazySingleton(() => GetActivityDetails(sl()));
    sl.registerLazySingleton(() => GetConsultationKey(sl()));
    sl.registerLazySingleton(() => GetCivilDefensePredefinedConditions(sl()));
    sl.registerLazySingleton(() => GetCleaningMechanisms(sl()));
    sl.registerLazySingleton(() => GetCommercialOffices(sl()));
    sl.registerLazySingleton(() => GetIssuingPredefinedConditions(sl()));
    sl.registerLazySingleton(() => GetLicensePermits(sl()));
    sl.registerLazySingleton(() => GetSupervisingAuthorities(sl()));
    sl.registerLazySingleton(() => SaveConsultationProgress(sl()));
    sl.registerLazySingleton(() => GetAccommodationTypes(sl()));

    //! Repository
    sl.registerLazySingleton<MunicipalAdvisorRepository>(
      () => MunicipalAdvisorRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<MunicipalAdvisorRemoteDataSource>(
      () => MunicipalAdvisorRemoteDataSourceImplementation(
        webService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => MunicipalAdvisorBloc(
        getConsultationKey: sl(),
        getIsicActivities: sl(),
        getIsicSubActivities: sl(),
        getActivityDetails: sl(),
        getGISData: sl(),
        getCleaningMechanisms: sl(),
        getCommercialOffices: sl(),
        getIssuingPredefinedConditions: sl(),
        getLicensePermits: sl(),
        getSupervisingAuthorities: sl(),
        getCivilDefensePredefinedConditions: sl(),
        saveConsultationProgress: sl(),
        getAccommodationTypes: sl(),
      ),
    );
  }
}
