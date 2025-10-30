import '../../../features/create_compliance/data/datasource/create_compliance_remote_data_source.dart';
import '../../../features/create_compliance/data/repository/repository_implementation.dart';
import '../../../features/create_compliance/domain/repositories/repository.dart';
import '../../../features/report_damaged_car/damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSourceImpl,
        DCRepositoryImpl,
        DCRemoteDataSource;
import '../dependency_injection_exports.dart' show sl;

class ComplianceInjection {
  static void init() {
    //! Repository
    sl.registerLazySingleton<CreateComplianceRepository>(
      () => CreateComplianceRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<CreateComplianceRemoteDataSource>(
      () => CreateComplianceRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
