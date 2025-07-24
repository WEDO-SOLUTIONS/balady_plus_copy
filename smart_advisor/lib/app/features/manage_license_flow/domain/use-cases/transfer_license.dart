import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/commercial_license_model.dart';
import '../repositories/repository.dart';

class TransferLicenseDraft
    implements UseCase<String, (int id, CommercialLicenseModel params)> {
  final ManageLicenseRepository repository;

  TransferLicenseDraft(this.repository);

  @override
  Future<Either<Failure, String>> call(params) async {
    return await repository.transferOwnershipCommercialLicense(
        params.$1, params.$2);
  }
}
