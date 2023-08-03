import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, MunicipalAdvisorRepository;

class SubmitConsultation extends UseCase<bool, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  SubmitConsultation(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    KeyParamsModel params,
  ) async {
    return await repository.submitConsultation(params);
  }
}
