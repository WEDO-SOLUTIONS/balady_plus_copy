import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/utils/utils_exports.dart' show LookupItem;
import '../../lookup_exports.dart' show LookupParams;

abstract class LookupRepository {
  Future<Either<Failure, List<LookupItem>>> lookup(LookupParams params);
}
