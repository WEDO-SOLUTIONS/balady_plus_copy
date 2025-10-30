import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../municipal_advisor_exports.dart' show MunicipalAdvisorRepository;

class GetIssuingPredefinedConditions extends UseCase<List<String>, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetIssuingPredefinedConditions(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getIssuingPredefinedConditions();
  }
}
