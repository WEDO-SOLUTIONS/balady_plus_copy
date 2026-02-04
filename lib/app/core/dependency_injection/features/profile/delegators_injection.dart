import 'package:balady_plus/app/features/delegators/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/delegators/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/delegators/domain/repositories/repository.dart';
import 'package:balady_plus/app/features/delegators/domain/use_cases/get_agents.dart';
import 'package:balady_plus/app/features/delegators/domain/use_cases/get_delegators.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';

import '../../dependency_injection_exports.dart' show sl;

class DelegatorsInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetDelegators(sl()));
    sl.registerLazySingleton(() => GetAgents(sl()));

    //! Repository
    sl.registerLazySingleton<DelegatorsRepository>(() => DelegatorsRepositoryImplementation(remoteDataSource: sl()));

    //! Data Sources
    sl.registerLazySingleton<DelegatorsRemoteDataSource>(
      () => DelegatorsRemoteDataSourceImplementation(webService: sl()),
    );

    //! Cubit
    sl.registerFactory(() => DelegatorsCubit(sl(), sl()));
  }
}
