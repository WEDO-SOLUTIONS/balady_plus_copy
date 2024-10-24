import '/app/features/fees_calculator/data/data_sources/remote_data_source.dart';
import '/app/features/fees_calculator/data/repositories/repository_implementation.dart';
import '/app/features/fees_calculator/domain/repositories/repository.dart';
import '../dependency_injection_exports.dart' show sl;

class CalculatorInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<CalculatorRepository>(
      () => CalculatorRepositoryImplementation(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<CalculatorRemoteDataSource>(
      () => CalculatorRemoteDataSourceImplementation(webService: sl()),
    );
  }
}
