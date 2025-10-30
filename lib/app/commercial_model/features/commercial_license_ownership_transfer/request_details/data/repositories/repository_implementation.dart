import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestOwnershipTransferRepositoryImplementation
    implements
        RequestOwnershipTransferDetailsRepository,
        AcceptOrRejectRequestOwnershipTransferRepository {
  final RequestOwnershipTransferDetailsRemoteDataSource remoteDataSource;

  RequestOwnershipTransferRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, CommercialLicenceDetails>>
      getRequestOwnershipTransferDetails(String commercialLicenseId) async {
    try {
      final data = await remoteDataSource
          .getRequestOwnershipTransferDetails(commercialLicenseId);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  Future<Either<Failure, bool>> acceptCommercialRequestTransfer(
      String commercialLicenseId) async {
    try {
      final data = await remoteDataSource
          .acceptCommercialRequestTransfer(commercialLicenseId);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  Future<Either<Failure, bool>> rejectCommercialRequestTransfer(
      String commercialLicenseId) async {
    try {
      final data = await remoteDataSource
          .rejectCommercialRequestTransfer(commercialLicenseId);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
