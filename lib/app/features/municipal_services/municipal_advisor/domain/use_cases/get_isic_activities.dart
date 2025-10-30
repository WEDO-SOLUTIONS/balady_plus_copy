import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../municipal_advisor_exports.dart'
    show IsicActivityEntity, MunicipalAdvisorRepository;

class GetIsicActivities extends UseCase<List<IsicActivityEntity>, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetIsicActivities(this.repository);

  @override
  Future<Either<Failure, List<IsicActivityEntity>>> call(
      NoParams params) async {
    return await repository.getIsicActivities();
  }
}
