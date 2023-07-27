import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, MunicipalAdvisorRepository;

class GetRequestFlowRecommendations
    extends UseCase<List<String>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetRequestFlowRecommendations(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(KeyParamsModel params) async {
    return await repository.getRequestFlowRecommendations(params);
  }
}
