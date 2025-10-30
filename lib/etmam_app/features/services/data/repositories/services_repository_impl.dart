import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/services/domain/entities/service_details/service_details_response.dart';
import 'package:balady_plus/etmam_app/features/services/domain/entities/service_details/service_details_params.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        ServicesRepository,
        ServiceResponse,
        ServiceParams,
        ServicesLocalDataSource,
        ServicesRemoteDataSource,
        ServicesCacheDataSource,
        RelationParams,
        RelationResponse;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;
  final ServicesCacheDataSource cacheDataSource;
  final ServicesLocalDataSource localDataSource;

  ServicesRepositoryImpl(
      {required this.remoteDataSource,
      required this.cacheDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<ServiceResponse>>> getServices(
      {required ServiceParams params}) async {
    try {
      final data = await remoteDataSource.getServices(params: params);

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

  @override
  Future<Either<Failure, ApigeeResponse<ServiceDetailsResponse>>>
      getServiceDetails({required ServiceDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getServiceDetails(params: params);

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
  Future<Either<Failure, ApigeeResponse<RelationResponse>>> getRelations(
      {required RelationParams params}) async {
    try {
      final data = await remoteDataSource.getRelations(params: params);

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
