
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/services/domain/use_cases/home_services_usecases.dart';
import 'package:balady_plus/app/features/services/services_exports.dart'
    show
    ServicesLocalDataSource,
    ServicesLocalDataSourceImplementation,
    ServicesRepository,
    ServicesRepositoryImplementation;


import 'package:get_it/get_it.dart';


final slHomeServices = GetIt.instance;

class HomeServicesInjectionContainer {
  static void init() {
    //! Use Case
    slHomeServices.registerLazySingleton(() => HomeServicesUseCases(slHomeServices()));

    //! Repository
    slHomeServices.registerLazySingleton<ServicesRepository>(
          () => ServicesRepositoryImplementation(localDataSource: slHomeServices()),
    );

    //! Data Sources
    slHomeServices.registerLazySingleton<ServicesLocalDataSource>(
          () => ServicesLocalDataSourceImplementation(webServices: sl<WebService>()),
    );
  }
}
