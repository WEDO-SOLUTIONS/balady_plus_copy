import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/entities/violation_details_params.dart';
import '../../violations_exports.dart'
    show
        InvoiceStatusesEntity,
        ViolationDetailsEntity,
        ViolationsEntity,
        ViolationsPrams,
        ViolationsRemoteDataSource,
        ViolationsRepository,
        ViolationsStatusEntity;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ViolationsRepositoryImplementation implements ViolationsRepository {
  final ViolationsRemoteDataSource remoteDataSource;

  ViolationsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ViolationDetailsEntity>> getViolationDetails(
      ViolationDetailsParams params) async {
    try {
      final data = await remoteDataSource.getViolationDetails(params);
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
  Future<Either<Failure, List<ViolationsStatusEntity>>>
      getViolationsStatus() async {
    try {
      final data = await remoteDataSource.getViolationsStatuses();
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
  Future<Either<Failure, List<InvoiceStatusesEntity>>>
      getInvoiceStatuses() async {
    try {
      final data = await remoteDataSource.getInvoiceStatuses();
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
  Future<Either<Failure, List<ViolationsEntity>>> getViolations(
      ViolationsPrams params) async {
    try {
      final data = await remoteDataSource.getViolations(params);
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
