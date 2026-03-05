import 'package:balady_plus/app/features/entry_point/data/models/test_model.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/get_permission_params_model.dart';
import '../../data/models/permission_response_model.dart';
import '../../entry_point_exports.dart';

abstract class EntryPointRepository {
  Future<Either<Failure, AuthorizationTokenResponse>> authorize();
  Future<Either<Failure, bool>> saveAuth(SSOToken params);
  Future<Either<Failure, SSOToken>> checkAuth();
  Future<Either<Failure, bool>> clearAuth();
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, TokenResponse>> refreshToken(String refreshToken);
  Future<Either<Failure, SsoUserInfo>> getSSOProfile();
  Future<Either<Failure, bool>> saveSSOProfile(SsoUserInfo params);
  Future<Either<Failure, SsoUserInfo>> checkSSOProfile();
  Future<Either<Failure, String>> getCookie();
  Future<Either<Failure, ApigeeTokenResponse>> getAPIgeeToken();
  Future<Either<Failure, PermissionResponseModel>> getEkramRules(GetPermissionParamsModel params);
  Future<Either<Failure, ForceUpdateResponse>> getForceVersion(ForceUpdateParams params);
  Future<Either<Failure, String>> getPaymentURL(PaymentRequest params);
  Future<Either<Failure, TestModel>> getDataTest();
}
