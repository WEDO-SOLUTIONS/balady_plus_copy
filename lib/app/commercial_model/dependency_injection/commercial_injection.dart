import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
////////////////////////////////////////////////
import 'package:balady_plus/app/commercial_model/dependency_injection/cr_injection.dart';
import 'package:balady_plus/app/commercial_model/dependency_injection/commercial_debt_injection.dart';
import 'package:balady_plus/app/commercial_model/dependency_injection/commercials_permits24_injection.dart';
import 'package:balady_plus/app/commercial_model/dependency_injection/commercials_posters_injection.dart';
import 'package:balady_plus/app/commercial_model/dependency_injection/commercials_tobacco_injection.dart';
import 'package:balady_plus/app/commercial_model/dependency_injection/renew_commercial_injection.dart';
////////////////////////////////////////////////
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/approval_sequence/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/approval_sequence/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/approval_sequence/domain/repositories/repository.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/old_owner_transfer/data/data_source/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/old_owner_transfer/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/old_owner_transfer/domain/repository/repository.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/domain/repositories/repository.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';

class CommercialInjectionContainer {
  static void init() {
  // transfer license ownership
    sl.registerLazySingleton<LicensePermitsRemoteDataSource>(
            () => LicensePermitsRemoteDataSourceImplementation(webService: sl()));
    sl.registerLazySingleton<TransferLicenseRepository>(
            () => TransferLicenseRepositoryImplementation(remoteDataSource: sl()));

    //transfer request ownership
    sl.registerLazySingleton<RequestOwnershipTransferDetailsRemoteDataSource>(
            () => RequestOwnershipTransferRemoteDataSourceImplementation(
            webService: sl()));

    sl.registerLazySingleton<RequestApprovalSequenceRepository>(() =>
        RequestApprovalSequenceRepositoryImplementation(remoteDataSource: sl()));

    sl.registerLazySingleton<RequestPermitsRemoteDataSource>(
            () => RequestPermitsRemoteDataSourceImplementation(webService: sl()));

    sl.registerLazySingleton<RequestOwnershipTransferDetailsRepository>(() =>
        RequestOwnershipTransferRepositoryImplementation(remoteDataSource: sl()));

    sl.registerLazySingleton<AcceptOrRejectRequestOwnershipTransferRepository>(
            () => RequestOwnershipTransferRepositoryImplementation(
            remoteDataSource: sl()));

    sl.registerLazySingleton<RequestOwnershipTransferDetailsCubit>(() =>
        RequestOwnershipTransferDetailsCubit(
            requestOwnershipTransferDetailsRepository: sl(),
            acceptOrRejectRequestOwnershipTransferRepository: sl()));


    //////////////////////////////////////////////////////////

    CrInjection.init();
    RenewCommercialInjection.init();
    CommercialsTobaccoInjection.init();
    CommercialsPostersInjection.init();
    CommercialsPermits24Injection.init();
    CommercialDebtInjection.init();

  }
}


