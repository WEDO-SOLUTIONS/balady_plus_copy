import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show KeyParamsModel, LicensePermitEntity, MunicipalAdvisorRepository;

class GetLicensePermits
    extends UseCase<List<LicensePermitEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetLicensePermits(this.repository);

  @override
  Future<Either<Failure, List<LicensePermitEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getLicensePermits(params);
  }
}
