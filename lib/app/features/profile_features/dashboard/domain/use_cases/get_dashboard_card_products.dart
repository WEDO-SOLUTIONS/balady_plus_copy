import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../dashboard_exports.dart';

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
