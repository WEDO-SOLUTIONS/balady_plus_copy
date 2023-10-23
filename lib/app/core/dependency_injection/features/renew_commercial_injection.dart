import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/events/data/datasource/events_data_source.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';

import '../../../features/comercial_license_renew/renew_commercial_license_exports.dart'
    show
        RenewCrRepository,
        RenewCrRepositoryImpl,
        RenewCrRemoteDataSource,
        RenewCrRemoteDataSourceImpl;

class RenewCommercialInjection {
  static void init() {
    sl.registerLazySingleton<RenewCrRepository>(
      () => RenewCrRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    sl.registerLazySingleton<RenewCrRemoteDataSource>(
      () => RenewCrRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
