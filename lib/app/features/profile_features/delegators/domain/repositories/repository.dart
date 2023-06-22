import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../delegators_exports.dart' show DelegatorEntity;

abstract class DelegatorsRepository {
  Future<Either<Failure, List<DelegatorEntity>>> getDelegators();
}
