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
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<DashboardProductEntity>>> getCardProducts(
      DashboardProductsParams params) async {
    try {
      final data = await remoteDataSource.getCardProducts(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<DashboardStatisticsEntity>>> getCardStatistics(
      DashboardStatisticsParams params) async {
    try {
      final data = await remoteDataSource.getCardStatistics(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
