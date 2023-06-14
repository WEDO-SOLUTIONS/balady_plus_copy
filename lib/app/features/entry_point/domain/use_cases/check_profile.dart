/*import 'package:balady_new_app/shared/core/services/services_exports.dart'
    show UseCase, NoParams;
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_new_app/shared/features/authorization/auth_exports.dart'
    show AuthRepository;
import 'package:balady_new_app/shared/features/authorization/domain/entities/profile.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class CheckProfile extends UseCase<Profile, NoParams> {
  final AuthRepository repository;

  CheckProfile({required this.repository});
  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.checkProfile();
  }
}
*/