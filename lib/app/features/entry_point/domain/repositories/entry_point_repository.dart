import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoType;
import '../../../_shared_feature_/shared_feature_exports.dart' show AuthData;

abstract class EntryPointRepository {
  //! key: is local storage key
  Future<Either<Failure, NoType>> clearAuth(String key);
  Future<Either<Failure, AuthData>> fetchAuth(String key);
  Future<Either<Failure, NoType>> persistAuth(String key,
      {required AuthData authData});
  Future<Either<Failure, NoType>> updateAuth(String key,
      {required AuthData newAuthData});
}
