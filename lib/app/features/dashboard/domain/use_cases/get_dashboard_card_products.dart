import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_product_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_products_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardCardProducts extends UseCase<List<DashboardProductEntity>, DashboardProductsParams> {
  final DashboardRepository repository;

  GetDashboardCardProducts({required this.repository});

  @override
  Future<Either<Failure, List<DashboardProductEntity>>> call(DashboardProductsParams params) async {
    return await repository.getCardProducts(params);
  }
}
