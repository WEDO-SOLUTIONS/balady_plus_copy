import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../../_shared_feature_/shared_feature_exports.dart' show AuthData;
import '../../entry_point_exports.dart'
    show EntryPointParams, EntryPointRepository;

class FetchAuth with UseCase<AuthData, EntryPointParams> {
  final EntryPointRepository repository;

  FetchAuth({required this.repository});

  @override
  Future<Either<Failure, AuthData>> call(EntryPointParams params) async {
    return await repository.fetchAuth(params.key);
  }
}
