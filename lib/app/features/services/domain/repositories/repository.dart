import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class ServicesRepository {

  Future<Either<Failure, HomeServices>> getAllServices();

}
