import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../dashboard_exports.dart'
    show
        DashboardRepository,
        DashboardStatisticsEntity,
        DashboardStatisticsParams;

class GetDashboardCardStatistics extends UseCase<
    List<DashboardStatisticsEntity>, DashboardStatisticsParams> {
  final DashboardRepository repository;

  GetDashboardCardStatistics({required this.repository});

  @override
  Future<Either<Failure, List<DashboardStatisticsEntity>>> call(
      DashboardStatisticsParams params) async {
    return await repository.getCardStatistics(params);
  }
}
