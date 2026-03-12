import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/events_logs/controller/logs_controller.dart';
import 'package:balady_plus/app/events_logs/events_names.dart';
import 'package:balady_plus/app/events_logs/models/error_exception_model.dart';
import 'package:balady_plus/app/features/dashboard/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/dashboard/data/models/volunteering_statistics_model.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_product_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_products_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

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
  Future<Either<Failure, List<DashboardProductEntity>>> getCardProducts(DashboardProductsParams params) async {
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
  Future<Either<Failure, List<DashboardStatisticsEntity>>> getCardStatistics(DashboardStatisticsParams params) async {
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

  @override
  Future<Either<Failure, VolunteeringStatisticsModel>> getVolunteeringStatistics() async {
    try {
      final data = await remoteDataSource.getVolunteeringStatistics();
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
