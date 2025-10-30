import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/classification_certificate/domain/use_cases/classification_certificate_use_cases.dart';

import '../../data/data_source/remote_data_source_implementation.dart';
import '../../data/repositories/classification_certificate_repository_implementation.dart';
import '../../domain/repository/classification_certificate_repository.dart';

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
    sl.registerLazySingleton<GetLookupsClassificationCertificateUseCases>(
      () => GetLookupsClassificationCertificateUseCases(
        repository: sl<ClassificationCertificateRepositoryImplementation>()
            as ClassificationCertificateLookupsRepository,
      ),
    );

    sl.registerLazySingleton<GetActivitiesClassificationCertificateUseCases>(
      () => GetActivitiesClassificationCertificateUseCases(
        repository: sl<ClassificationCertificateRepositoryImplementation>()
            as ClassificationCertificateLookupsRepository,
      ),
    );

    sl.registerLazySingleton<SearchClassificationCertificateUseCases>(
      () => SearchClassificationCertificateUseCases(
        repository: sl<ClassificationCertificateRepositoryImplementation>()
            as ClassificationCertificateSearchRepository,
      ),
    );

    sl.registerLazySingleton<GetDetailsClassificationCertificateUseCases>(
      () => GetDetailsClassificationCertificateUseCases(
        repository: sl<ClassificationCertificateRepositoryImplementation>()
            as DetailsClassificationCertificateRepository,
      ),
    );

    sl.registerLazySingleton<GetAttachedClassificationCertificateUseCases>(
      () => GetAttachedClassificationCertificateUseCases(
        repository: sl<ClassificationCertificateRepositoryImplementation>()
            as DetailsClassificationCertificateRepository,
      ),
    );
  }
}
