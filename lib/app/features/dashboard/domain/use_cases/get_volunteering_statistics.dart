import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/volunteering_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetVolunteeringStatistics extends UseCase<VolunteeringStatisticsEntity, NoParams> {
  final DashboardRepository repository;

  GetVolunteeringStatistics({required this.repository});

  @override
  Future<Either<Failure, VolunteeringStatisticsEntity>> call(NoParams params) async {
    return await repository.getVolunteeringStatistics();
  }
}
