import 'package:dartz/dartz.dart' show Either, Left, Right;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../damaged_cars_exports.dart'
    show
        DCRepository,
        DCRemoteDataSource,
        ActiveLocationParams,
        CarModel,
        CarType;
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../vd/vd_exports.dart'
    show CreateIncidentParams, CreateIncidentResponse;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class DCRepositoryImpl implements DCRepository {
  final DCRemoteDataSource remoteDataSource;

  DCRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentRegistered({required CreateIncidentParams params}) async {
    try {
      final data =
          await remoteDataSource.createIncidentRegistered(params: params);

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
  Future<Either<Failure, List<CarModel>>> getCarModels(
      {required String params}) async {
    try {
      final data = await remoteDataSource.getCarModels(params: params);

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
  Future<Either<Failure, List<CarType>>> getCarTypes() async {
    try {
      final data = await remoteDataSource.getCarTypes();

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
  Future<Either<Failure, bool>> checkActiveLocation(
      {required ActiveLocationParams params}) async {
    try {
      final data = await remoteDataSource.checkActiveLocation(params: params);

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
