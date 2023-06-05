import 'package:dartz/dartz.dart' show Either;

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../_shared_feature_/shared_feature_exports.dart' show AuthData;
import '../../sign_in_exports.dart' show SignInParams;

abstract class SignInRepository {
  Future<Either<Failure, AuthData>> byPhoneNumber(SignInParams params);
  Future<Either<Failure, AuthData>> byUsernameAndPassword(SignInParams params);
}
