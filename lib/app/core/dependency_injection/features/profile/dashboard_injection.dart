import 'package:balady_plus/app/features/dashboard/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/dashboard/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_card_products.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_card_statistics.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_cards.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_volunteering_statistics.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../dependency_injection_exports.dart' show sl;

class DashboardInjection {
  static void init() {
    //! Use Cases
    sl.registerLazySingleton(() => GetDashboardCards(repository: sl()));
    sl.registerLazySingleton(() => GetDashboardCardProducts(repository: sl()));
    sl.registerLazySingleton(() => GetDashboardCardStatistics(repository: sl()));
    sl.registerLazySingleton(() => GetVolunteeringStatistics(repository: sl()));

    //! Repository
    sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImplementation(remoteDataSource: sl()));

    //! Data Sources
    sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImplementation(webService: sl()),
    );

    //! Bloc - Using Factory to create new instances
    sl.registerFactory(
      () => DashboardBloc(
        getDashboardCards: sl(),
        getDashboardProducts: sl(),
        getDashboardStatistics: sl(),
        getVolunteeringStatistics: sl(),
      ),
    );
  }
}
