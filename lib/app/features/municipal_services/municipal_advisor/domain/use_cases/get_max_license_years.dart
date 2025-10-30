import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, MunicipalAdvisorRepository;

class GetMaxLicenseYears extends UseCase<int, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetMaxLicenseYears(this.repository);

  @override
  Future<Either<Failure, int>> call(KeyParamsModel params) async {
    return await repository.getMaxLicenseYears(params);
  }
}
