import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show
        ActivityDetailsEntity,
        ActivityDetailsParams,
        MunicipalAdvisorRepository;

class GetActivityDetails
    extends UseCase<ActivityDetailsEntity, ActivityDetailsParams> {
  final MunicipalAdvisorRepository repository;

  GetActivityDetails(this.repository);

  @override
  Future<Either<Failure, ActivityDetailsEntity>> call(
      ActivityDetailsParams params) async {
    return await repository.getActivityDetails(params);
  }
}
