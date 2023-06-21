import 'package:dartz/dartz.dart' show Either;

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../../../_shared_feature_/shared_feature_exports.dart' show AuthData;
import '../../sign_in_exports.dart' show SignInParams, SignInRepository;

class SignInByUsernameAndPassword implements UseCase<AuthData, SignInParams> {
  final SignInRepository repository;

  SignInByUsernameAndPassword({required this.repository});

  @override
  Future<Either<Failure, AuthData>> call(SignInParams params) async {
    return await repository.byUsernameAndPassword(params);
  }
}
