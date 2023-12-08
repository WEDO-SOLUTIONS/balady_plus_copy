import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/use_cases/create_profile.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';

import '../dependency_injection_exports.dart' show sl;

class AuthInjection {
  static void init() {
    sl.registerLazySingleton(() => EtmamEntryPointCubit(
        checkProfile: sl(),
        getProfile: sl(),
        saveProfile: sl(),
        createProfile: sl(),
        updateProfile: sl(),
        updateDeviceToken: sl(),
        forceVersion: sl()));

    //! Use Case
    sl.registerLazySingleton(() => CheckProfile(repository: sl()));
    sl.registerLazySingleton(() => SaveProfile(repository: sl()));
    sl.registerLazySingleton(() => GetProfile(repository: sl()));
    sl.registerLazySingleton(() => CreateProfile(repository: sl()));
    sl.registerLazySingleton(() => UpdateProfile(repository: sl()));
    sl.registerLazySingleton(() => UpdateDeviceToken(repository: sl()));
    sl.registerLazySingleton(() => GetForceVersion(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<EtmamEntryPointRepository>(
      () => EtmamEntryPointRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<EtmamEntryPointLocalDataSource>(
      () => EtmamEntryPointLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(webService: sl()),
    );
  }
}
