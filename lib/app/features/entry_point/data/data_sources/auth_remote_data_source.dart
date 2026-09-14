import 'dart:convert';

import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:developer' as devtools show log;
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_plus/app/features/entry_point/data/models/get_permission_params_model.dart';
import 'package:balady_plus/app/features/entry_point/data/models/permission_response_model.dart';
import 'package:flutter/foundation.dart';

abstract class EntryPointRemoteDataSource {
  Future<AuthorizationTokenResponse> authorize();
  Future<bool> endSession();
  Future<String> logout();

  Future<TokenResponse> refreshToken(String refreshToken);
  Future<SsoUserInfoModel?> getSSOProfile();
  Future<String?> getCookie();
  Future<ApigeeTokenResponse> getAPIgeeToken();
  Future<ForceUpdateResponseModel> getForceVersion({required ForceUpdateParams params});

  Future<dynamic> getDataTest();
  Future<PermissionResponseModel> getEkramRules({required GetPermissionParamsModel params});

  Future<String> getPaymentURL({required PaymentRequest params});
}

class EntryPointRemoteDataSourceImpl extends EntryPointRemoteDataSource {
  final WebService webService;

  final WebService webServiceSSo = WebService.newDio(dio: CommonFunctions.getDio(baseUrl: RemoteConfig.ssoUrl));

  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final AuthorizationServiceConfiguration _serviceConfiguration = AuthorizationServiceConfiguration(
    authorizationEndpoint: '${RemoteConfig.ssoUrl}/connect/authorize',
    tokenEndpoint: '${RemoteConfig.ssoUrl}/connect/token',
    endSessionEndpoint: "${RemoteConfig.ssoUrl}/connect/endsession",
  ); //https://ssoappdev.momra.gov.sa/connect/endsession

  EntryPointRemoteDataSourceImpl({required this.webService});

  @override
  Future<AuthorizationTokenResponse> authorize() async {
    try {
      debugPrint("ssoClient:${RemoteConfig.ssoClient}");

      debugPrint("ssoLoginUrl:${RemoteConfig.ssoLoginUrl}");
      debugPrint("ssoLoginUrl:${RemoteConfig.ssoLoginUrl}");
      debugPrint("ssoSecret:${RemoteConfig.ssoSecret}");

      final request = AuthorizationTokenRequest(
        RemoteConfig.ssoClient,
        RemoteConfig.ssoLoginUrl,
        serviceConfiguration: _serviceConfiguration,
        clientSecret: RemoteConfig.ssoSecret,
        scopes: ['openid', 'profile', "IdentityServerApi", 'offline_access', 'EmployeeAdminstration.Api'],
      );
      AuthorizationTokenResponse? response = await _appAuth.authorizeAndExchangeCode(request);

      response.accessToken.actionLog();
      await sharedPrefs.setIsNafathLogin(response.idToken);
      return response;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      final request = TokenRequest(
        RemoteConfig.ssoClient,
        RemoteConfig.ssoLoginUrl,
        serviceConfiguration: _serviceConfiguration,
        refreshToken: refreshToken,
        clientSecret: RemoteConfig.ssoSecret,
        scopes: ['openid', 'profile', 'offline_access'],
      );
      TokenResponse? response = await _appAuth.token(request);
      return response;
    } on PlatformException catch (error) {
      final errorMessage = error.toString();
      if (errorMessage.contains("invalid_grant")) {
        sl<EntryPointCubit>().autoLogout();
      }
      throw ServerException(errorMessage);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SsoUserInfoModel?> getSSOProfile() async {
    Response? response;
    try {
      response = await webServiceSSo.dio.get(
        ApiUrl.ssoUserInfo,
        options: Options(headers: {"Authorization": "Bearer ${CommonProperties.token}"}),
      );

      var data = response.data;
      if (data == null) {
        return null;
      }

      var parsedResult = SsoUserInfoModel.fromJson(data);

      return parsedResult;
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (e) {
      throw serverException(e, response);
    }
  }

  @override
  Future<String> logout() async {
    Response? response;
    try {
      if (sl<EntryPointCubit>().state.token != null) {
        response = await webService.dio.get(
          "${RemoteConfig.ssoUrl}/connect/endsession",
          queryParameters: {
            "id_token_hint": sl<EntryPointCubit>().state.token!.idToken,
            "post_logout_redirect_uri": RemoteConfig.ssoLogOutUrl,
          },
        );
        return response.data.toString();
      } else {
        return "";
      }
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      throw serverException(ex, response);
    }
  }

  @override
  Future<bool> endSession() async {
    try {
      String? idToken = sharedPrefs.getIsNafathLogin();
      if (idToken != null) {
        EndSessionRequest endSessionRequest = EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: RemoteConfig.ssoLogOutUrl,
          serviceConfiguration: _serviceConfiguration,
          additionalParameters: {
            // "id_token_hint": idToken,
            // "post_logout_redirect_uri": RemoteConfig.ssoLogOutUrl
          },
        );
        await _appAuth.endSession(endSessionRequest);
        await sharedPrefs.setIsNafathLogin(null);
        return true;
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException("", errorCode: error.toString());
    }
  }

  @override
  Future<String?> getCookie() async {
    const key = 'set-cookie';
    Response? response;
    try {
      response = await webServiceSSo.dio.get(
        ApiUrl.ssoUserCookie,
        options: Options(headers: {"Authorization": "Bearer ${CommonProperties.token}"}),
      );
      if (response.headers.map.containsKey(key)) {
        final value = response.headers.map[key];
        return value.toString();
      }
      return null;
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      throw serverException(ex, response);
    }
  }

  @override
  Future<ApigeeTokenResponse> getAPIgeeToken() async {
    Response? response;
    try {
      final username = RemoteConfig.apigeeUsername;
      final password = RemoteConfig.apigeePassword;
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      response = await webService.dio.post(
        ApiUrl.apigeeToken,
        options: Options(headers: {"Content-Type": "application/x-www-form-urlencoded", "Authorization": basicAuth}),
        data: {"grant_type": "client_credentials"},
      );

      ApigeeTokenResponseModel apigeeResponse = ApigeeTokenResponseModel.fromMap(response.data);
      return apigeeResponse.toFuture();
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      throw serverException(ex, response);
    }
  }

  @override
  Future getDataTest() async {
    try {
      final response = await webService.dio.get(ApiUrl.dashboardCards);

      var data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.toFuture();
    } on DioException catch (error) {
      error.errorLog();
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      ex.errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<PermissionResponseModel> getEkramRules({required GetPermissionParamsModel params}) async {
    Response? response;

    try {
      response = await webService.dio.post(ApiUrl.ekramRules, data: params.toMap());
      devtools.log(response.data["data"]);
      var data = response.data["data"]?["result"];
      if (data == null) {
        throw ServerException("errors_server_error_2".tr());
      }
      var parsedResult = PermissionResponseModel.fromMap(data);

      return parsedResult;
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      devtools.log(ex.toString());
      throw serverException(ex, response);
    }
  }

  @override
  Future<String> getPaymentURL({required PaymentRequest params}) async {
    Response? response;

    try {
      response = await webService.dio.post(ApiUrl.paymentURL, data: params.toMap());
      devtools.log(response.toString());
      devtools.log(response.data["data"]);
      return response.data["data"]?["result"];
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      devtools.log(ex.toString());
      throw serverException(ex, response);
    }
  }

  // HANDLERS

  @override
  Future<ForceUpdateResponseModel> getForceVersion({required ForceUpdateParams params}) async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.forceUpdate,
        queryParameters: {ApiParam.type.name: params.type, ApiParam.appID.name: params.appId},
      );

      final data = response.data["data"]?["result"];
      if (data == null) {
        throw ServerException("errors_server_error_2".tr());
      }

      var parsedResult = ForceUpdateResponseModel.fromMap(data);

      return parsedResult;
    } on DioException catch (error) {
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } on ServerException catch (e) {
      devtools.log(e.toString());
      rethrow;
    } catch (ex) {
      throw serverException(ex, response);
    }
  }

  Exception serverException(Object ex, Response? response) => ServerException(
    "errors_server_error_2".tr(),
    exception: APIException(errorMessage: ex.toString()),
    response: response,
  );
}
