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
    sl.registerLazySingleton(() => GetGISData(repository: sl()));

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
