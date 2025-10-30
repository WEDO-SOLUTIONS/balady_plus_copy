import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../licenses_exports.dart' show LicenseTypeEntity, LicensesRepository;

class GetLicenseTypes extends UseCase<List<LicenseTypeEntity>, NoParams> {
  final LicensesRepository repository;

  GetLicenseTypes({required this.repository});

  @override
  Future<Either<Failure, List<LicenseTypeEntity>>> call(NoParams params) async {
    return await repository.getLicenseTypes();
  }
}
