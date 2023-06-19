import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        GetCategories,
        GetSpecialClassifications,
        GetGISData,
        UploadFile,
        GetOTP,
        CreateIncidentUnRegistered,
        CreateIncidentRegistered,
        GetSPLDetails,
        VDRepository,
        VDRepositoryImpl,
        CheckCR,
        VDLocalDataSource,
        VDLocalDataSourceImpl,
        VDRemoteDataSourceImpl,
        VDRemoteDataSource,
        VDCategoryBloc;

import '../dependency_injection_exports.dart' show sl;

class VDInjection {
  static void init() {
    sl.registerLazySingleton(() => VDCategoryBloc(getCategories: sl()));

    //! Use Case
    sl.registerLazySingleton(() => GetCategories(repository: sl()));
    sl.registerLazySingleton(() => GetSpecialClassifications(repository: sl()));
    sl.registerLazySingleton(() => GetSPLDetails(repository: sl()));

    sl.registerLazySingleton(() => GetGISData(repository: sl()));
    sl.registerLazySingleton(() => UploadFile(repository: sl()));
    sl.registerLazySingleton(() => GetOTP(repository: sl()));
    sl.registerLazySingleton(
        () => CreateIncidentUnRegistered(repository: sl()));
    sl.registerLazySingleton(() => CreateIncidentRegistered(repository: sl()));
    sl.registerLazySingleton(() => CheckCR(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<VDRepository>(
      () => VDRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<VDLocalDataSource>(
      () => VDLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<VDRemoteDataSource>(
      () => VDRemoteDataSourceImpl(webService: sl()),
    );
  }
}
