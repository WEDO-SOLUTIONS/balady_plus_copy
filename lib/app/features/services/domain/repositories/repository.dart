import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../services_exports.dart' show ServiceEntity;

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getIslamicServices();
  Future<Either<Failure, List<ServiceEntity>>> getCustomerVoiceServices();
  Future<Either<Failure, List<ServiceEntity>>> getBusinessLicenseServices();
  Future<Either<Failure, List<ServiceEntity>>> getHonoringTheDeadServices();
  Future<Either<Failure, List<ServiceEntity>>> getHealthCertificatesServices();
  Future<Either<Failure, List<ServiceEntity>>> getHelpServices();

  Future<Either<Failure, List<ServiceEntity>>> getNewServices();
  Future<Either<Failure, List<ServiceEntity>>> getImportantServices();
}
