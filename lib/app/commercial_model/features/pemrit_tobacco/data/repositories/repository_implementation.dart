import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/allowed_actions_response.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/calculate_cost_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/permit_request_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/permit_submit_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/permits_alerts_response.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/data/models/validate_hotel_license.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/domain/entities/permit_tobacco_caclualte_request.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_tobacco/domain/entities/validate_hotel_license_request.dart';
import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/entities/submit_tobacco_request.dart';
import '../../domain/repositores/repository.dart';
import '../data_sources/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class PermitsTobaccoRepositoryImplementation
    implements PermitsTobaccoRepository {
  final PermitsTobaccoRemoteDataSource remoteDataSource;

  PermitsTobaccoRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, CalculateCostPermitTobaccoResponse>>
      calculatePermit24HourCost(
          {required PermitTobaccoCalculateRequest params}) async {
    try {
      final data =
          await remoteDataSource.calculatePermit24HourCost(params: params);
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
  Future<Either<Failure, bool>> deletePermitRequest(
      {required int requestId}) async {
    try {
      final data =
          await remoteDataSource.deletePermitRequest(requestId: requestId);
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
  Future<Either<Failure, PermitTobaccoAllowedAction>> getPermitAllowedActions(
      {required int params}) async {
    try {
      final data =
          await remoteDataSource.getPermitAllowedActions(params: params);
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
  Future<Either<Failure, PermitTobaccoRequestDetailsModel>>
      getPermitRequestDetails({required int params}) async {
    try {
      final data =
          await remoteDataSource.getPermitRequestDetails(params: params);
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
  Future<Either<Failure, PermitTobaccoAlertsResponse>>
      getPermitsAlerts() async {
    try {
      final data = await remoteDataSource.getPermitsAlerts();
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
  Future<Either<Failure, PermitTobaccoSubmitResponseModel>> submit(
      {required SubmitTobaccoRequest params}) async {
    try {
      final data = await remoteDataSource.submit(params: params);
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
  Future<Either<Failure, bool>> validateBeforeApply(
      {required int params}) async {
    try {
      final data = await remoteDataSource.validateBeforeApply(params: params);
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
  Future<Either<Failure, PermitTobaccoValidateHotelLicense>>
      validateHotelLicense(
          {required ValidateHotelLicenseRequest params}) async {
    try {
      final data = await remoteDataSource.validateHotelLicense(params: params);
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
