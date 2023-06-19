import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../licenses_exports.dart'
    show
        LicensesRepository,
        LicensesRemoteDataSource,
        LicenseEntity,
        LicenseStatusEntity,
        LicenseSubTypeEntity,
        LicenseSubTypeParamsModel,
        LicenseTypeEntity,
        LicensesPrams;

class LicensesRepositoryImplementation implements LicensesRepository {
  final LicensesRemoteDataSource remoteDataSource;

  LicensesRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<LicenseEntity>>> getLicenses(
    LicensesPrams params,
  ) async {
    try {
      final data = await remoteDataSource.getLicenses(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LicenseStatusEntity>>>
      getLicenseStatuses() async {
    try {
      final data = await remoteDataSource.getLicenseStatuses();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LicenseTypeEntity>>> getLicenseTypes() async {
    try {
      final data = await remoteDataSource.getLicenseTypes();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LicenseSubTypeEntity>>> getLicenseSubTypes(
    LicenseSubTypeParamsModel params,
  ) async {
    try {
      final data = await remoteDataSource.getLicenseSubTypes(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
