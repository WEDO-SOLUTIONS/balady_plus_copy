import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show EngineeringOfficeEntity, KeyParamsModel, MunicipalAdvisorRepository;

class GetEngineeringOffices
    extends UseCase<List<EngineeringOfficeEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetEngineeringOffices(this.repository);

  @override
  Future<Either<Failure, List<EngineeringOfficeEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getEngineeringOffices(params);
  }
}
