import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../objections_exports.dart'
    show
        RequestsRepository,
        RequestsRemoteDataSource,
        ObjectionEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        ObjectionsRequestsPrams;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestsRepositoryImplementation implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ObjectionEntity>>> getObjectionRequests(
    ObjectionsRequestsPrams params,
  ) async {
    try {
      final data = await remoteDataSource.getObjectionRequests(params);
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
  Future<Either<Failure, List<RequestStatusEntity>>>
      getRequestStatuses() async {
    try {
      final data = await remoteDataSource.getRequestStatuses();
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
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes() async {
    try {
      final data = await remoteDataSource.getRequestTypes();
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
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getRequestSubTypes(params);
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
  Future<Either<Failure, ObjectionDetails>> getObjectionDetails(
      String id) async {
    try {
      final data = await remoteDataSource.getObjectionDetails(id);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelObjection(String id) async {
    try {
      final data = await remoteDataSource.cancelObjection(id);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> getPermitURL(String id) async {
    try {
      final data = await remoteDataSource.getPermitURL(id);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
