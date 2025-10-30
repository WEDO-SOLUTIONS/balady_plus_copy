import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show SaveActivitiesParams, MunicipalAdvisorRepository;

class SaveActivities extends UseCase<bool, SaveActivitiesParams> {
  final MunicipalAdvisorRepository repository;

  SaveActivities(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveActivitiesParams params) async {
    return await repository.saveActivities(params);
  }
}
