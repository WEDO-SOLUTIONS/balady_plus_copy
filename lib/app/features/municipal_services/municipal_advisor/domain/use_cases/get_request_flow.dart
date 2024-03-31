import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, MunicipalAdvisorRepository, RequestStepModel;

class GetRequestFlow extends UseCase<List<RequestStepModel>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetRequestFlow(this.repository);

  @override
  Future<Either<Failure, List<RequestStepModel>>> call(
      KeyParamsModel params) async {
    return await repository.getRequestFlow(params);
  }
}
