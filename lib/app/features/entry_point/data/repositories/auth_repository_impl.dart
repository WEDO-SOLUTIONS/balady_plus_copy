import 'package:balady_plus/app/features/entry_point/data/models/test_model.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure, AuthNotFoundedFailure;
import '../../entry_point_exports.dart';
import '../models/get_permission_params_model.dart';
import '../models/permission_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class EntryPointRepositoryImpl implements EntryPointRepository {
  final EntryPointRemoteDataSource remoteDataSource;
  final EntryPointLocalDataSource localDataSource;
//
  EntryPointRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, AuthorizationTokenResponse>> authorize() async {
    try {
      final data = await remoteDataSource.authorize();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAuth(SSOToken params) async {
    try {
      final data = await localDataSource.saveAuth(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, SSOToken>> checkAuth() async {
    try {
      final data = await localDataSource.getAuth();
      return Right(data);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(AuthNotFoundedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> clearAuth() async {
    try {
      await localDataSource.clearAuth();
      final data = await remoteDataSource.endSession();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString(), statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, TokenResponse>> refreshToken(String refreshToken) async {
    try {
      final data = await remoteDataSource.refreshToken(refreshToken);
      return Right(data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(""));
    }
  }

  /*@override
  Future<Either<Failure, ApigeeResponse<Profile>>> getProfile() async {
    try {
      final data = await remoteDataSource.getProfile();

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  /*@override
  Future<Either<Failure, Profile>> checkProfile() async {
    try {
      final data = await localDataSource.checkProfile();
      return Right(data);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(AuthNotFoundedFailure());
    }
  }*/

  /* @override
  Future<Either<Failure, bool>> saveProfile(Profile params) async {
    try {
      final data = await localDataSource.saveProfile(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  /*@override
  Future<Either<Failure, ApigeeResponse<String>>> createProfile(
      CraeteProfileParams params) async {
    try {
      final data = await remoteDataSource.createProfile();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  /*@override
  Future<Either<Failure, ApigeeResponse>> updateProfile(
      UpdateProfileParams params) async {
    try {
      final data = await remoteDataSource.updateProfile(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  /*@override
  Future<Either<Failure, ApigeeResponse<AddDeviceResponse>>> addDeviceToken(
      AddDeviceParams params) async {
    try {
      final data = await remoteDataSource.addDeviceToken(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  /* @override
  Future<Either<Failure, ApigeeResponse<UpdateDeviceResponse>>>
      updateDeviceToken(UpdateDeviceParams params) async {
    try {
      final data = await remoteDataSource.updateDeviceToken(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }*/

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final data = await remoteDataSource.logout();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ForceUpdateResponse>> getForceVersion(ForceUpdateParams params) async {
    try {
      final data = await remoteDataSource.getForceVersion(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, SsoUserInfo>> getSSOProfile() async {
    try {
      final data = await remoteDataSource.getSSOProfile();
      if (data != null)
        return Right(data);
      else
        return Left(ServerFailure(""));
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> saveSSOProfile(SsoUserInfo params) async {
    try {
      final data = await localDataSource.saveSSOProfile(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, SsoUserInfo>> checkSSOProfile() async {
    try {
      final data = await localDataSource.checkSSOProfile();
      return Right(data);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(AuthNotFoundedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getCookie() async {
    try {
      final data = await remoteDataSource.getCookie();
      if (data != null)
        return Right(data);
      else
        return Left(ServerFailure(
          "",
        ));
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeTokenResponse>> getAPIgeeToken() async {
    try {
      final data = await remoteDataSource.getAPIgeeToken();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, TestModel>> getDataTest() async {
    try {
      final data = await remoteDataSource.getDataTest();
      return Right(data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, PermissionResponseModel>> getEkramRules(GetPermissionParamsModel params) async {
    try {
      final data = await remoteDataSource.getEkramRules(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> getPaymentURL(PaymentRequest params) async {
    try {
      final data = await remoteDataSource.getPaymentURL(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
