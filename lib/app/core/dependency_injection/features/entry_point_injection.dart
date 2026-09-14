import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';

import '../../../features/entry_point/entry_point_exports.dart'
    show
        CheckAuth,
        CheckSSOProfile,
        ClearAuth,
        EntryPointLocalDataSource,
        EntryPointLocalDataSourceImpl,
        EntryPointRemoteDataSource,
        EntryPointRemoteDataSourceImpl,
        EntryPointRepository,
        EntryPointRepositoryImpl,
        GetAPIgeeToken,
        GetCookie,
        GetForceVersion,
        GetProfile,
        GetToken,
        Logout,
        RefreshToken,
        SaveAuth,
        SaveSSOProfile;
import '../dependency_injection_exports.dart' show sl;

class EntryPointInjection {
  static void init() {
    sl.registerLazySingleton(
      () => EntryPointCubit(
        clearAuth: sl(),
        // checkProfile: sl(),
        getProfile: sl(),
        saveSSOProfile: sl(),
        getToken: sl(),
        saveAuth: sl(),
        getCookie: sl(),
        getAPIgeeToken: sl(),
        logout: sl(),
        forceVersion: sl(),
      ),
    );

    //! Use Case
    sl.registerLazySingleton(() => GetToken(repository: sl()));
    sl.registerLazySingleton(() => ClearAuth(repository: sl()));
    sl.registerLazySingleton(() => SaveAuth(repository: sl()));
    sl.registerLazySingleton(() => RefreshToken(repository: sl()));
    sl.registerLazySingleton(() => CheckAuth(repository: sl()));
    sl.registerLazySingleton(() => SaveSSOProfile(repository: sl()));
    sl.registerLazySingleton(() => CheckSSOProfile(repository: sl()));

    sl.registerLazySingleton(() => GetProfile(repository: sl()));
    sl.registerLazySingleton(() => GetCookie(repository: sl()));
    sl.registerLazySingleton(() => GetAPIgeeToken(repository: sl()));

    sl.registerLazySingleton(() => Logout(repository: sl()));
    sl.registerLazySingleton(() => GetForceVersion(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<EntryPointRepository>(
      () => EntryPointRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<EntryPointLocalDataSource>(() => EntryPointLocalDataSourceImpl());
    sl.registerLazySingleton<EntryPointRemoteDataSource>(() => EntryPointRemoteDataSourceImpl(webService: sl()));
  }
}
