import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class CheckAuth extends UseCase<SSOToken, NoParams> {
  final EntryPointRepository repository;

  CheckAuth({required this.repository});
  @override
  Future<Either<Failure, SSOToken>> call(NoParams params) async {
    return await repository.checkAuth();
  }
}
