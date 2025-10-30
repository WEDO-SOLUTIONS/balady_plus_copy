import 'package:balady_plus/etmam_app/features/home/domain/use_cases/get_ads.dart';

import '../dependency_injection_exports.dart' show sl;
import '../../../features/home/home_exports.dart'
    show
        GetMainServices,
        GetSubService,
        GetTopOrderedSubService,
        GetTopRatedProviders,
        HomeCacheDataSource,
        HomeCacheDataSourceImpl,
        HomeRemoteDataSource,
        HomeRemoteDataSourceImpl,
        HomeLocalDataSource,
        HomeRepository,
        HomeLocalDataSourceImpl,
        HomeRepositoryImpl;

class HomeInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetMainServices(repository: sl()));
    sl.registerLazySingleton(() => GetSubService(repository: sl()));

    sl.registerLazySingleton(() => GetTopOrderedSubService(repository: sl()));

    sl.registerLazySingleton(() => GetTopRatedProviders(repository: sl()));
    sl.registerLazySingleton(() => GetAds(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), cacheDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(),
    );

    sl.registerLazySingleton<HomeCacheDataSource>(
      () => HomeCacheDataSourceImpl(),
    );
  }
}
