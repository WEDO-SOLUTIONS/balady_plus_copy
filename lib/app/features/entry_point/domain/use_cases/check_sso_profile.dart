import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class CheckSSOProfile extends UseCase<SsoUserInfo, NoParams> {
  final EntryPointRepository repository;

  CheckSSOProfile({required this.repository});
  @override
  Future<Either<Failure, SsoUserInfo>> call(NoParams params) async {
    return await repository.checkSSOProfile();
  }
}
