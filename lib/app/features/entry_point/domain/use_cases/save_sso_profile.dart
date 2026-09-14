import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../entry_point_exports.dart';

class SaveSSOProfile extends UseCase<bool, SsoUserInfo> {
  final EntryPointRepository repository;

  SaveSSOProfile({required this.repository});
  @override
  Future<Either<Failure, bool>> call(SsoUserInfo params) async {
    return await repository.saveSSOProfile(params);
  }
}
