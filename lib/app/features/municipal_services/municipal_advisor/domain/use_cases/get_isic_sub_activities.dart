import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show IsicActivityEntity, IsicSubActivityParams, MunicipalAdvisorRepository;

class GetIsicSubActivities
    extends UseCase<List<IsicActivityEntity>, IsicSubActivityParams> {
  final MunicipalAdvisorRepository repository;

  GetIsicSubActivities(this.repository);

  @override
  Future<Either<Failure, List<IsicActivityEntity>>> call(
      IsicSubActivityParams params) async {
    return await repository.getIsicSubActivities(params);
  }
}
