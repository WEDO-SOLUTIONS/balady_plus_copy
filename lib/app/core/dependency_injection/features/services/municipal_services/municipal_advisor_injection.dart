import '../../../../../features/municipal_services/municipal_advisor/municipal_advisor_exports.dart'
    show CalculateLicenseFees, GetAccommodationTypes, GetActivityDetails, GetBoardTypes, GetCivilDefensePredefinedConditions, GetCleaningMechanisms, GetCommercialOffices, GetConditionsUrls, GetConsultationAttachments, GetConsultationKey, GetFastflowConditions, GetIsicActivities, GetIsicSubActivities, GetIssuingPredefinedConditions, GetLicensePermits, GetLicenseYears, GetMaxLicenseYears, GetRequestFlow, GetRequestFlowRecommendations, GetShopOwnership, GetSupervisingAuthorities, MunicipalAdvisorBloc, MunicipalAdvisorRemoteDataSource, MunicipalAdvisorRemoteDataSourceImplementation, MunicipalAdvisorRepository, MunicipalAdvisorRepositoryImplementation, SaveActivities, SaveConsultationProgress, SaveFinancialStudy, UpdatePermit;
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
    sl.registerLazySingleton(() => SaveActivities(sl()));
    sl.registerLazySingleton(() => GetLicenseYears(sl()));
    sl.registerLazySingleton(() => GetBoardTypes(sl()));
    sl.registerLazySingleton(() => CalculateLicenseFees(sl()));
    sl.registerLazySingleton(() => SaveFinancialStudy(sl()));
    sl.registerLazySingleton(() => GetShopOwnership(sl()));
    sl.registerLazySingleton(() => GetConsultationAttachments(sl()));
    sl.registerLazySingleton(() => GetMaxLicenseYears(sl()));
    sl.registerLazySingleton(() => GetConditionsUrls(sl()));
    sl.registerLazySingleton(() => GetFastflowConditions(sl()));
    sl.registerLazySingleton(() => GetRequestFlow(sl()));
    sl.registerLazySingleton(() => GetRequestFlowRecommendations(sl()));
    sl.registerLazySingleton(() => UpdatePermit(sl()));

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
        boardTypes: sl(),
        calculateLicenseFeed: sl(),
        saveActivities: sl(),
        getLicenseYears: sl(),
        saveFinancialStudy: sl(),
        getShopOwnership: sl(),
        getConsultationAttachments: sl(),
        getMaxLicenseYears: sl(),
        getConditionsUrls: sl(),
        getFastflowConditions: sl(),
        getRequestFlow: sl(),
        getRequestFlowRecommendations: sl(),
        updatePermit: sl(),
      ),
    );
  }
}
