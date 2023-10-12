import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class Logout extends UseCase<String, NoParams> {
  final EntryPointRepository repository;

  Logout({required this.repository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.logout();
  }
}
