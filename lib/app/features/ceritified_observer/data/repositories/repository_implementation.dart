import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/observer_status_entity.dart';

import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class CertifiedObserverRepositoryImplementation implements CertifiedObserverRepository {
  final CertifiedObserverRemoteDataSource remoteDataSource;

  CertifiedObserverRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<ObserverStatusEntity>>> getObserverStatus(String identityNumber) async {
    try {

      final data = await remoteDataSource.getObserverStatus(identityNumber);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
