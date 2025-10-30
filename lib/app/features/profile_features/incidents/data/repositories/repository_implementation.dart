import 'package:balady_plus/app/features/profile_features/incidents/data/models/request_details_response.dart';
import 'package:balady_plus/app/features/profile_features/incidents/domain/entities/request_details_response.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/download_file_result.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/entities/download_file_params.dart';
import '../../domain/entities/reply_retrive_car_params.dart';
import '../../domain/entities/reply_retrive_car_response.dart';
import '../../requests_exports.dart'
    show RequestsRepository, RequestsRemoteDataSource;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, RequestDetailsResponse>> getCRMINQRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMINQRequestDetails(params);
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
  Future<Either<Failure, RequestDetailsResponse>> getCRMIncidentRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMIncidentRequestDetails(params);
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
  Future<Either<Failure, RequestDetailsResponse>> getCRMREQRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getCRMREQRequestDetails(params);
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
  Future<Either<Failure, CrmRequestDetails>> getDCRequestDetails(
      String params) async {
    try {
      final data = await remoteDataSource.getRequestDetails(params: params);
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
  Future<Either<Failure, DownloadFileResult?>> downloadFile(
      DownLoadFileParams params) async {
    try {
      final data = await remoteDataSource.downloadFile(params: params);
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
  Future<Either<Failure, ReplyRetriveCarResponse>> replyRetriveCar(
      {required ReplyRetriveCarParams params}) async {
    try {
      final data = await remoteDataSource.replyRetriveCar(params: params);

      return Right(data);
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
}
