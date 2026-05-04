import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_product_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_products_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/volunteering_statistics_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardCardEntity>>> getDashboardCards();

  Future<Either<Failure, List<DashboardProductEntity>>> getCardProducts(DashboardProductsParams params);

  Future<Either<Failure, List<DashboardStatisticsEntity>>> getCardStatistics(DashboardStatisticsParams params);

  Future<Either<Failure, VolunteeringStatisticsEntity>> getVolunteeringStatistics();
}
