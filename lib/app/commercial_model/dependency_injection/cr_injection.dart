import '../features/commercial_license/commercial_license_exports.dart';
import '../../core/dependency_injection/dependency_injection_exports.dart' show sl;
import '../features/commercial_license_approvel_export/data/data_sources/remote_data_source.dart';
import '../features/commercial_license_approvel_export/data/repositories/repository_impl.dart';
import '../features/commercial_license_approvel_export/domain/repositories/repository.dart';
import '../features/commercial_license_approvel_export/presentation/export_commercial_license/license_export_intiation/blocs/commercial_license_export_bloc.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';


class CrInjection {
  static void init() {
    sl.registerLazySingleton(() => CommercialLicenseBloc());

    //! Repository
    sl.registerLazySingleton<CrRepository>(
      () => CrRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<CrRemoteDataSource>(
      () => CrRemoteDataSourceImpl(
        webService: sl(),
      ),
    );




    sl.registerLazySingleton<Repository>(
          () => RepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<RemoteDataSource>(
          () => RemoteDataSourceImpl(
        webService: sl(),
      ),
    );

    sl.registerLazySingleton(() => CommercialLicenseInitialAprrovalBloc());
    sl.registerLazySingleton(() => Step1ApplicantDataExportCubit());
    sl.registerLazySingleton(() => Step2ActivityDataExportCubit());

    sl.registerLazySingleton(() => CommercialLicenseExportBloc());



  }
}
