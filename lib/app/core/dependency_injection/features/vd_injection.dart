import 'package:balady_plus/app/features/location/data/data_sources/vd_local_data_source.dart';
import 'package:balady_plus/app/features/location/data/data_sources/vd_remote_data_source.dart';
import 'package:balady_plus/app/features/location/data/repositories/vd_repository_impl.dart';
import 'package:balady_plus/app/features/location/domain/repositories/vd_repository.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';

import '../dependency_injection_exports.dart' show sl;

class VDInjection {
  static void init() {
    //! Use Case

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
