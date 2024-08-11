import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../dashboard_exports.dart'
    show
        DashboardRepository,
        DashboardRemoteDataSource,
        DashboardCardEntity,
        DashboardProductEntity,
        DashboardProductsParams,
        DashboardStatisticsEntity,
        DashboardStatisticsParams;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class DashboardRepositoryImplementation implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<DashboardCardEntity>>> getDashboardCards() async {
    try {
      final data = await remoteDataSource.getDashboardCards();
      return Right(data);
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
  Future<Either<Failure, List<DashboardProductEntity>>> getCardProducts(
      DashboardProductsParams params) async {
    try {
      final data = await remoteDataSource.getCardProducts(params);
      return Right(data);
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
  Future<Either<Failure, List<DashboardStatisticsEntity>>> getCardStatistics(
      DashboardStatisticsParams params) async {
    try {
      final data = await remoteDataSource.getCardStatistics(params);
      return Right(data);
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
