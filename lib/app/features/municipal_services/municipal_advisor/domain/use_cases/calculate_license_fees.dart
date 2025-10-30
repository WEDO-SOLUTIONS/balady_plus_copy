import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show LicenseFeesEntity, MunicipalAdvisorRepository, CalculateFeesParams;

class CalculateLicenseFees
    extends UseCase<LicenseFeesEntity, CalculateFeesParams> {
  final MunicipalAdvisorRepository repository;

  CalculateLicenseFees(this.repository);

  @override
  Future<Either<Failure, LicenseFeesEntity>> call(
      CalculateFeesParams params) async {
    return await repository.calculateLicenseFees(params);
  }
}
