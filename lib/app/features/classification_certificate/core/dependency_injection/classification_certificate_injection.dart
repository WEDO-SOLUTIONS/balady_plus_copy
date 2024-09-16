import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';

import '../../data/data_source/remote_data_source_implementation.dart';
import '../../data/repositories/classification_certificate_repository_implementation.dart';
import '../../domain/use_cases/get_construction_license_inquery_data.dart';

class ClassificationCertificateInjectionContainer {
  static void init() {
    // Remote DataSource
    sl.registerLazySingleton<ClassificationCertificateRemoteDataSource>(
      () => ClassificationCertificateRemoteDataSource(
        webService: sl<WebService>(),
      ),
    );
    //////////////////////////////////////////////////////////////////////
    // Repository
    sl.registerLazySingleton<ClassificationCertificateRepositoryImplementation>(
          () => ClassificationCertificateRepositoryImplementation(
            remoteDataSource: sl<ClassificationCertificateRemoteDataSource>(),
      ),
    );
    //////////////////////////////////////////////////////////////////////
    // Use Cases
    sl.registerLazySingleton<SearchClassificationCertificateUseCases>(
          () => SearchClassificationCertificateUseCases(
          repository: sl<ClassificationCertificateRepositoryImplementation>(),
      ),
    );
  }
}
