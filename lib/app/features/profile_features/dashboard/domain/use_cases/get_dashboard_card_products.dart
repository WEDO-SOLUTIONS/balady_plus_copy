import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../dashboard_exports.dart'
    show DashboardProductEntity, DashboardProductsParams, DashboardRepository;

class GetDashboardCardProducts
    extends UseCase<List<DashboardProductEntity>, DashboardProductsParams> {
  final DashboardRepository repository;

  GetDashboardCardProducts({required this.repository});

  @override
  Future<Either<Failure, List<DashboardProductEntity>>> call(
      DashboardProductsParams params) async {
    return await repository.getCardProducts(params);
  }
}
