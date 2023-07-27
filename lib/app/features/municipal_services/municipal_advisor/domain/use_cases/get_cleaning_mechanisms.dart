import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show CleaningEntity, KeyParamsModel, MunicipalAdvisorRepository;

class GetCleaningMechanisms
    extends UseCase<List<CleaningEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetCleaningMechanisms(this.repository);

  @override
  Future<Either<Failure, List<CleaningEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getCleaningMechanisms(params);
  }
}
