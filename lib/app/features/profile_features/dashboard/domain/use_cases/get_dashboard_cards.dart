import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../dashboard_exports.dart'
    show DashboardCardEntity, DashboardRepository;

class GetDashboardCards extends UseCase<List<DashboardCardEntity>, NoParams> {
  final DashboardRepository repository;

  GetDashboardCards({required this.repository});

  @override
  Future<Either<Failure, List<DashboardCardEntity>>> call(
      NoParams params) async {
    return await repository.getDashboardCards();
  }
}
