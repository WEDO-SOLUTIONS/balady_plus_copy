import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../entry_point_exports.dart';

class SaveAuth extends UseCase<bool, SSOToken> {
  final EntryPointRepository repository;

  SaveAuth({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SSOToken params) async {
    return await repository.saveAuth(params);
  }
}
