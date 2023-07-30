import '../dependency_injection_exports.dart' show sl;
import '../../../features/otp/otp_exports.dart'
    show
        SendOTP,
        VerifyOTP,
        OTPRepository,
        OTPRepositoryImpl,
        OTPRemoteDataSource,
        OTPRemoteDataSourceImpl,
        OTPLocalDataSource,
        OTPLocalDataSourceImpl;

class OTPInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => SendOTP(repository: sl()));
    sl.registerLazySingleton(() => VerifyOTP(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<OTPRepository>(
      () => OTPRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<OTPRemoteDataSource>(
      () => OTPRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<OTPLocalDataSource>(
      () => OTPLocalDataSourceImpl(),
    );
  }
}
