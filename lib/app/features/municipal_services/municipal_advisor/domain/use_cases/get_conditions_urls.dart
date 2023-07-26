import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../municipal_advisor_exports.dart'
    show ConditionsUrlsEntity, MunicipalAdvisorRepository;

class GetConditionsUrls extends UseCase<ConditionsUrlsEntity, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetConditionsUrls(this.repository);

  @override
  Future<Either<Failure, ConditionsUrlsEntity>> call(
    NoParams params,
  ) async {
    return await repository.getConditionsUrls();
  }
}
