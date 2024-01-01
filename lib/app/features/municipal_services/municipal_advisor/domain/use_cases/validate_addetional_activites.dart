import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart' show MunicipalAdvisorRepository;
import '../entities/validate_additional_activities_params.dart';

class ValidateAddetionalActivites
    extends UseCase<bool, ValidateAdditionalActivitiesParams> {
  final MunicipalAdvisorRepository repository;

  ValidateAddetionalActivites(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      ValidateAdditionalActivitiesParams params) async {
    return await repository.validateAdditionalActivities(params);
  }
}
