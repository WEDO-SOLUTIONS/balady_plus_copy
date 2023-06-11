import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../services_exports.dart' show ServiceEntity;

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getPublicServices();
  Future<Either<Failure, List<ServiceEntity>>> getMunicipalServices();
  Future<Either<Failure, List<ServiceEntity>>> getNewServices();
  Future<Either<Failure, List<ServiceEntity>>> getImportantServices();
}
