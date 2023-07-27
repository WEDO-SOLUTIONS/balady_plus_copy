import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show
        UpdatePermitParamsModel,
        LicensePermitEntity,
        MunicipalAdvisorRepository;

class UpdatePermit
    extends UseCase<LicensePermitEntity, UpdatePermitParamsModel> {
  final MunicipalAdvisorRepository repository;

  UpdatePermit(this.repository);

  @override
  Future<Either<Failure, LicensePermitEntity>> call(
    UpdatePermitParamsModel params,
  ) async {
    return await repository.updatePermit(params);
  }
}
