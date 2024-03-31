/*import 'package:balady_plus/shared/core/services/services_exports.dart'
    show UseCase;
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/shared/features/authorization/auth_exports.dart'
    show AuthRepository;
import 'package:balady_plus/shared/features/authorization/domain/entities/profile.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class SaveProfile extends UseCase<bool, Profile> {
  final AuthRepository repository;

  SaveProfile({required this.repository});
  @override
  Future<Either<Failure, bool>> call(Profile params) async {
    return await repository.saveProfile(params);
  }
}
*/
