import '../../../../features/profile_features/dashboard/dashboard_exports.dart'
    show
        DashboardBloc,
        DashboardRemoteDataSource,
        DashboardRemoteDataSourceImplementation,
        DashboardRepository,
        DashboardRepositoryImplementation,
        GetDashboardCardProducts,
        GetDashboardCardStatistics,
        GetDashboardCards;
import '../../dependency_injection_exports.dart' show sl;

class DashboardInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetDashboardCards(repository: sl()));
    sl.registerLazySingleton(() => GetDashboardCardProducts(repository: sl()));
    sl.registerLazySingleton(
      () => GetDashboardCardStatistics(repository: sl()),
    );

    //! Repository
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImplementation(
        webService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => DashboardBloc(
        getDashboardCards: sl(),
        getDashboardProducts: sl(),
        getDashboardStatistics: sl(),
      ),
    );
  }
}
