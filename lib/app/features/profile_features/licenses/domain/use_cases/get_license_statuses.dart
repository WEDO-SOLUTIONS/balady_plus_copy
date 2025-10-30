import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../licenses_exports.dart'
    show LicenseStatusEntity, LicensesRepository;

class GetLicenseStatuses extends UseCase<List<LicenseStatusEntity>, NoParams> {
  final LicensesRepository repository;

  GetLicenseStatuses({required this.repository});

  @override
  Future<Either<Failure, List<LicenseStatusEntity>>> call(
      NoParams params) async {
    return await repository.getLicenseStatuses();
  }
}
