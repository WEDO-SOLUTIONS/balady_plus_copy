import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoType, UseCase;
import '../../entry_point_exports.dart'
    show EntryPointParams, EntryPointRepository;

class ClearAuth with UseCase<NoType, EntryPointParams> {
  final EntryPointRepository repository;

  ClearAuth({required this.repository});

  @override
  Future<Either<Failure, NoType>> call(EntryPointParams params) async {
    return await repository.clearAuth(params.key);
  }
}
