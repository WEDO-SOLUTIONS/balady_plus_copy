import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, SupervisingAuthorityEntity, MunicipalAdvisorRepository;

class GetSupervisingAuthorities
    extends UseCase<List<SupervisingAuthorityEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetSupervisingAuthorities(this.repository);

  @override
  Future<Either<Failure, List<SupervisingAuthorityEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getSupervisingAuthorities(params);
  }
}
