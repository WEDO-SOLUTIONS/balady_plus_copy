import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show FastflowConditionEntity, KeyParamsModel, MunicipalAdvisorRepository;

class GetFastflowConditions
    extends UseCase<List<FastflowConditionEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetFastflowConditions(this.repository);

  @override
  Future<Either<Failure, List<FastflowConditionEntity>>> call(
    KeyParamsModel params,
  ) async {
    return await repository.getFastflowConditions(params);
  }
}
