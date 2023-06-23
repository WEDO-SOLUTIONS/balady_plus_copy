import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../../../core/utils/utils_exports.dart' show LookupItem;
import '../../lookup_exports.dart' show LookupParams, LookupRepository;

//! SU: Sign-Up
class GetLookup implements UseCase<List<LookupItem>, LookupParams> {
  final LookupRepository repository;

  GetLookup({required this.repository});

  @override
  Future<Either<Failure, List<LookupItem>>> call(LookupParams params) async {
    return await repository.lookup(params);
  }
}
