import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/permits_response_entity.dart';
import '../../domain/entity/transfer_license_request.dart';
import '../../domain/entity/validate_owner_entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import '../model/apply_request_data_model.dart';
import '../model/validate_license_data_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class TransferLicenseRepositoryImplementation
    implements TransferLicenseRepository {
  final LicensePermitsRemoteDataSource remoteDataSource;

  TransferLicenseRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<PermitsResponseEntity>>>
      getLicensePermits(String licenseNumber) async {
    try {
      final data = await remoteDataSource.getLicensePermits(licenseNumber);
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

  @override
  Future<Either<Failure, ResponseBodyModel<ValidateOwnerEntity>>>
      validateNewOwner(String licenseNumber, String crNumber) async {
    try {
      final data =
          await remoteDataSource.validateNewOwner(licenseNumber, crNumber);
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
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<ValidateLicenseDataModel>>>
      validateLicense(String licenseNumber) async {
    try {
      final data = await remoteDataSource.validateLicense(licenseNumber);
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

  @override
  Future<Either<Failure, ResponseBodyModel<ApplyRequestDataModel>>>
      sendToNewOwner(
          String licenseNumber, TransferLicenseRequest request) async {
    try {
      final data =
          await remoteDataSource.sendToNewOwner(licenseNumber, request);
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
