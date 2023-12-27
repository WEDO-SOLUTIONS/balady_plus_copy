import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/create_profile_params.dart';

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure, AuthNotFoundedFailure;

class EtmamEntryPointRepositoryImpl implements EtmamEntryPointRepository {
  final AuthRemoteDataSource remoteDataSource;
  final EtmamEntryPointLocalDataSource localDataSource;
//
  EtmamEntryPointRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<Profile>>> getProfile() async {
    try {
      final data = await remoteDataSource.getProfile();

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, Profile>> checkProfile() async {
    try {
      final data = await localDataSource.checkProfile();
      return Right(data);
    } on Exception catch (error) {
      return Left(AuthNotFoundedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveProfile(Profile params) async {
    try {
      final data = await localDataSource.saveProfile(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<String>>> createProfile(
      CraeteProfileParams params) async {
    try {
      final data = await remoteDataSource.createProfile();
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> updateProfile(
      UpdateProfileParams params) async {
    try {
      final data = await remoteDataSource.updateProfile(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<AddDeviceResponse>>> addDeviceToken(
      AddDeviceParams params) async {
    try {
      final data = await remoteDataSource.addDeviceToken(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<UpdateDeviceResponse>>>
      updateDeviceToken(UpdateDeviceParams params) async {
    try {
      final data = await remoteDataSource.updateDeviceToken(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ForceUpdateResponse>> getForceVersion(
      ForceUpdateParams params) async {
    try {
      final data = await remoteDataSource.getForceVersion(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
