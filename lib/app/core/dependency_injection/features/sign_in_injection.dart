import '../dependency_injection_exports.dart' show sl;

import '../../../features/authentication/sign_in/sign_in_exports.dart'
    show
        SignInByPhoneNumber,
        SignInByUsernameAndPassword,
        SignInParams,
        SignInRemoteDataSource,
        SignInRemoteDataSourceImplementation,
        SignInRepository,
        SignInRepositoryImplementation;

class SignInInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => SignInByPhoneNumber(repository: sl()));
    sl.registerLazySingleton(
      () => SignInByUsernameAndPassword(repository: sl()),
    );

    //! Entities
    sl.registerLazySingleton(() => const SignInParams());

    //! Repository
    sl.registerLazySingleton<SignInRepository>(
      () => SignInRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<SignInRemoteDataSource>(
      () => SignInRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
