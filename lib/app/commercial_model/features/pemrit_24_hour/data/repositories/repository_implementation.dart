import 'package:balady_plus/app/commercial_model/features/pemrit_24_hour/data/models/allowed_actions_response.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_24_hour/data/models/permit_request_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_24_hour/data/models/permit_submit_response_model.dart';
import 'package:balady_plus/app/commercial_model/features/pemrit_24_hour/data/models/permits_alerts_response.dart';

import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/repositores/repository.dart';
import '../data_sources/remote_data_source.dart';
import '../models/calculate_cost_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class Permits24RepositoryImplementation implements Permits24Repository {
  final Permits24RemoteDataSource remoteDataSource;

  Permits24RepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, CalculateCost24PermitResponse>>
      calculatePermit24HourCost({required int params}) async {
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
  Future<Either<Failure, Permit24AllowedAction>> getPermitAllowedActions(
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
  Future<Either<Failure, Permit24RequestDetailsModel>> getPermitRequestDetails(
      {required int params}) async {
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
  Future<Either<Failure, PermitAlertsResponse>> getPermitsAlerts(
      String type) async {
    try {
      final data = await remoteDataSource.getPermitsAlerts(type);
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
  Future<Either<Failure, PermitSubmitResponseModel>> submit(
      {required int params}) async {
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
}
