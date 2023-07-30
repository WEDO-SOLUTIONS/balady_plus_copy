import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show
        CityRepository,
        GetCities,
        CityRepositoryImpl,
        CityRemoteDataSource,
        CityRemoteDataSourceImpl,
        CityLocalDataSource,
        CityLocalDataSourceImpl;
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/blocs/city_bloc.dart';

import '../dependency_injection_exports.dart' show sl;

class CityInjection {
  static void init() {
    sl.registerLazySingleton(() => CityBloc(getCities: sl()));

    //! Use Case
    sl.registerLazySingleton(() => GetCities(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<CityRepository>(
      () => CityRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<CityRemoteDataSource>(
      () => CityRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<CityLocalDataSource>(
      () => CityLocalDataSourceImpl(),
    );
  }
}
