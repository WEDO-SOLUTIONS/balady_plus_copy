import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/license_model.dart';
import '../entities/license_request_params.dart';
import '../repositories/repository.dart';

class GetLicenses
    implements UseCase<List<LicensesResponseItem>, LicenseRequestParams> {
  final ManageLicenseRepository repository;

  GetLicenses(this.repository);

  @override
  Future<Either<Failure, List<LicensesResponseItem>>> call(
      LicenseRequestParams params) async {
    return await repository.getLicenses(params);
  }
}
