import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, MunicipalAdvisorRepository;
import '../entities/civil_defence_entity.dart';

class GetCivilDefenseConditions
    extends UseCase<List<CivilDefenceEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetCivilDefenseConditions(this.repository);

  @override
  Future<Either<Failure, List<CivilDefenceEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getCivilDefenseConditions(params);
  }
}
