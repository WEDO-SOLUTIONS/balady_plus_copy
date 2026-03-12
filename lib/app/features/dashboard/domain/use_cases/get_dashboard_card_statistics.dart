import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart' show UseCase;
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardCardStatistics extends UseCase<List<DashboardStatisticsEntity>, DashboardStatisticsParams> {
  final DashboardRepository repository;

  GetDashboardCardStatistics({required this.repository});

  @override
  Future<Either<Failure, List<DashboardStatisticsEntity>>> call(DashboardStatisticsParams params) async {
    return await repository.getCardStatistics(params);
  }
}
