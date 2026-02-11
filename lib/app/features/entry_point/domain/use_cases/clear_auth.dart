import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class ClearAuth extends UseCase<bool, NoParams> {
  final EntryPointRepository repository;

  ClearAuth({required this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.clearAuth();
  }
}
