import '../../../features/report_damaged_car/damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSourceImpl,
        DCRepositoryImpl,
        DCRemoteDataSource;

import '../../../features/weather_alerts/data/datasource/weather_alerts_remote_data_source.dart';
import '../../../features/weather_alerts/data/repository/weather_alerts_repository_implementation.dart';
import '../../../features/weather_alerts/domain/repository/weather_alerts_repository.dart';
import '../dependency_injection_exports.dart' show sl;

class WeatherAlertsInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<WeatherAlertsRepository>(
      () => WeatherAlertsRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<WeatherAlertsRemoteDataSource>(
      () => WeatherAlertsRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
