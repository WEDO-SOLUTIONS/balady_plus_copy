import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/license_details_model.dart';
import '../repositories/repository.dart';

class GetLicenseDetails implements UseCase<LicenseDetails, String> {
  final ManageLicenseRepository repository;

  GetLicenseDetails(this.repository);

  @override
  Future<Either<Failure, LicenseDetails>> call(String params) async {
    return await repository.getLicenseDetails(params);
  }
}
