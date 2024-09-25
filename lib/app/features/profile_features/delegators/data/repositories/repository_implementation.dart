import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/profile_features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/profile_features/delegators/domain/entities/delegator_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../delegators_exports.dart'
    show DelegatorsRepository, DelegatorsRemoteDataSource;

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
