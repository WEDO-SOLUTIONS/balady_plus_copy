import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../dashboard_exports.dart'
    show
        DashboardCardEntity,
        DashboardProductEntity,
        DashboardProductsParams,
        DashboardStatisticsEntity,
        DashboardStatisticsParams;

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardCardEntity>>> getDashboardCards();
  Future<Either<Failure, List<DashboardProductEntity>>> getCardProducts(
      DashboardProductsParams params);
  Future<Either<Failure, List<DashboardStatisticsEntity>>> getCardStatistics(
      DashboardStatisticsParams params);
}
