import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../licenses_exports.dart'
    show LicensesRepository, LicenseSubTypeEntity, LicenseSubTypeParams;

class GetLicenseSubTypes
    extends UseCase<List<LicenseSubTypeEntity>, LicenseSubTypeParams> {
  final LicensesRepository repository;

  GetLicenseSubTypes({required this.repository});

  @override
  Future<Either<Failure, List<LicenseSubTypeEntity>>> call(
      LicenseSubTypeParams params) async {
    return await repository.getLicenseSubTypes(params);
  }
}
