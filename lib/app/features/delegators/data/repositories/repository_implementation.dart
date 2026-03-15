import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:dartz/dartz.dart';

import '../../delegators_exports.dart'
    show AgentEntity, DelegatorEntity, DelegatorsRemoteDataSource, DelegatorsRepository;

class DelegatorsRepositoryImplementation implements DelegatorsRepository {
  final DelegatorsRemoteDataSource remoteDataSource;

  DelegatorsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<DelegatorEntity>>> getDelegators() async {
    try {
      final data = await remoteDataSource.getDelegators();
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
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<AgentEntity>>> getAgents() async {
    try {
      final data = await remoteDataSource.getAgents();
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
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }
}
