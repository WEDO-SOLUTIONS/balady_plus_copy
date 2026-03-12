import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardCards extends UseCase<List<DashboardCardEntity>, NoParams> {
  final DashboardRepository repository;

  GetDashboardCards({required this.repository});

  @override
  Future<Either<Failure, List<DashboardCardEntity>>> call(NoParams params) async {
    return await repository.getDashboardCards();
  }
}
