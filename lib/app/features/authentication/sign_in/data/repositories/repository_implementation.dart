import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../../../_shared_feature_/shared_feature_exports.dart' show AuthData;
import '../../sign_in_exports.dart'
    show SignInParams, SignInRemoteDataSource, SignInRepository;

class SignInRepositoryImplementation implements SignInRepository {
  final SignInRemoteDataSource remoteDataSource;

  SignInRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthData>> byPhoneNumber(SignInParams params) async {
    try {
      final authData = await remoteDataSource.byPhoneNumber(params);
      return Right(authData);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, AuthData>> byUsernameAndPassword(
    SignInParams params,
  ) async {
    try {
      final authData = await remoteDataSource.byUsernameAndPassword(params);
      return Right(authData);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
