import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../licenses_exports.dart'
    show LicenseEntity, LicensesPrams, LicensesRepository;

class GetLicenses extends UseCase<List<LicenseEntity>, LicensesPrams> {
  final LicensesRepository repository;

  GetLicenses({required this.repository});

  @override
  Future<Either<Failure, List<LicenseEntity>>> call(
      LicensesPrams params) async {
    return await repository.getLicenses(params);
  }
}
