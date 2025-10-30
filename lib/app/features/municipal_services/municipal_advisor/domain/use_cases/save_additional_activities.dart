import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show AdditionalActivitiesParams, MunicipalAdvisorRepository;

class SaveAdditionalActivities
    extends UseCase<bool, AdditionalActivitiesParams> {
  final MunicipalAdvisorRepository repository;

  SaveAdditionalActivities(this.repository);

  @override
  Future<Either<Failure, bool>> call(AdditionalActivitiesParams params) async {
    return await repository.saveAdditionalActivities(params);
  }
}
