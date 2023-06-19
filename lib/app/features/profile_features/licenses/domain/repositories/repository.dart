import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../licenses_exports.dart'
    show
        LicenseEntity,
        LicenseStatusEntity,
        LicenseSubTypeEntity,
        LicenseSubTypeParamsModel,
        LicenseTypeEntity,
        LicensesPrams;

abstract class LicensesRepository {
  Future<Either<Failure, List<LicenseEntity>>> getLicenses(
    LicensesPrams params,
  );
  Future<Either<Failure, List<LicenseStatusEntity>>> getLicenseStatuses();
  Future<Either<Failure, List<LicenseTypeEntity>>> getLicenseTypes();
  Future<Either<Failure, List<LicenseSubTypeEntity>>> getLicenseSubTypes(
    LicenseSubTypeParamsModel params,
  );
}
