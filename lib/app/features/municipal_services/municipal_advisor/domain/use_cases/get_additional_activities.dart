import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show
        ActivityDetailsEntity,
        ActivityDetailsParams,
        MunicipalAdvisorRepository;

class GetAdditionalActivities
    extends UseCase<List<ActivityDetailsEntity>, ActivityDetailsParams> {
  final MunicipalAdvisorRepository repository;

  GetAdditionalActivities(this.repository);

  @override
  Future<Either<Failure, List<ActivityDetailsEntity>>> call(
      ActivityDetailsParams params) async {
    return await repository.getAdditionalActivities(params);
  }
}
