import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/utils/utils_exports.dart' show Log, StringConversion;
import '../../../../core/errors/errors_exports.dart'
    show AuthNotFoundedException, AuthNotFoundedFailure, Failure;
import '../../../../core/services/services_exports.dart' show NoType;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show AuthData, AuthDataModelFromEntity;
import '../../entry_point_exports.dart'
    show EntryPointLocalDataSource, EntryPointRepository;

class EntryPointRepositoryImplementation implements EntryPointRepository {
  final EntryPointLocalDataSource localDataSource;

  EntryPointRepositoryImplementation({required this.localDataSource});

  @override
  Future<Either<Failure, NoType>> clearAuth(String key) async {
    await localDataSource.clearAuth(key);
    "Authentication deleted successfully".hardcoded.successLog();
    return Right(NoType());
  }

  @override
  Future<Either<Failure, AuthData>> fetchAuth(String key) async {
    try {
      final authData = await localDataSource.fetchAuth(key);
      "Authentication founded successfully".hardcoded.successLog();
      return Right(authData);
    } on AuthNotFoundedException {
      "Authentication founded error".hardcoded.errorLog();
      return Left(AuthNotFoundedFailure());
    }
  }

  @override
  Future<Either<Failure, NoType>> persistAuth(
    String key, {
    required AuthData authData,
  }) async {
    final authDataModel = authData.toModel;
    await localDataSource.persistAuth(key, authDataModel: authDataModel);
    "Authentication persisted successfully".hardcoded.successLog();
    return Right(NoType());
  }

  @override
  Future<Either<Failure, NoType>> updateAuth(
    String key, {
    required AuthData newAuthData,
  }) async {
    final newAuthDataModel = newAuthData.toModel;
    await localDataSource.updateAuth(key, newAuthDataModel: newAuthDataModel);
    "Authentication updated successfully".hardcoded.successLog();
    return Right(NoType());
  }
}
