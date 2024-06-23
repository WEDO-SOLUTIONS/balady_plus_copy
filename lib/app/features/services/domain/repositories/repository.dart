import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../services_exports.dart' show ServiceEntity;

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getIslamicServices();
  Future<Either<Failure, List<ServiceEntity>>> getBusinessLicenseServices();
  //Future<Either<Failure, List<ServiceEntity>>> getHealthCertificatesServices();
  Future<Either<Failure, List<ServiceEntity>>> getHelpServices();

  Future<Either<Failure, List<ServiceEntity>>> getMunicipalServices();

  Future<Either<Failure, List<ServiceEntity>>> getEkramServices();
}
