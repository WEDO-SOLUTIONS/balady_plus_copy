import '../../../../../features/municipal_services/municipal_advisor/municipal_advisor_exports.dart'
    show
        GetActivityDetails,
        GetIsicActivities,
        GetIsicSubActivities,
        MunicipalAdvisorBloc,
        MunicipalAdvisorRemoteDataSource,
        MunicipalAdvisorRemoteDataSourceImplementation,
        MunicipalAdvisorRepository,
        MunicipalAdvisorRepositoryImplementation;
import '../../../dependency_injection_exports.dart' show sl;

class MunicipalAdvisorInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetIsicActivities(sl()));
    sl.registerLazySingleton(() => GetIsicSubActivities(sl()));
    sl.registerLazySingleton(() => GetActivityDetails(sl()));

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
        getIsicActivities: sl(),
        getIsicSubActivities: sl(),
        getActivityDetails: sl(),
        getGISData: sl(),
      ),
    );
  }
}
