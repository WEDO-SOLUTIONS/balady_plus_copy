import 'dart:convert';

import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/data/models/test_model.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../entry_point_exports.dart';
import '../models/get_permission_params_model.dart';
import '../models/permission_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class EntryPointRemoteDataSource {
  Future<AuthorizationTokenResponse> authorize();
  Future<EndSessionResponse> endSession();
  Future<String> logout();

  Future<TokenResponse> refreshToken(String refreshToken);
  Future<SsoUserInfoModel?> getSSOProfile();
  Future<String?> getCookie();
  Future<ApigeeTokenResponse> getAPIgeeToken();
  Future<ForceUpdateResponseModel> getForceVersion(
      {required ForceUpdateParams params});

  Future<dynamic> getDataTest();
  Future<PermissionResponseModel> getEkramRules(
      {required GetPermissionParamsModel params});

  Future<String> getPaymentURL({required PaymentRequest params});
}

class EntryPointRemoteDataSourceImpl extends EntryPointRemoteDataSource {
  final WebService webService;

  final WebService webServiceSSo = WebService.newDio(
      dio: CommonFunctions.getDio(baseUrl: RemoteConfig.ssoUrl));

  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
    authorizationEndpoint: '${RemoteConfig.ssoUrl}/connect/authorize',
    tokenEndpoint: '${RemoteConfig.ssoUrl}/connect/token',
    endSessionEndpoint: "${RemoteConfig.ssoUrl}/connect/endsession",
  );

  EntryPointRemoteDataSourceImpl({required this.webService});

  @override
  Future<AuthorizationTokenResponse> authorize() async {
    try {
      AuthorizationTokenResponse? response =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          RemoteConfig.ssoClient,
          RemoteConfig.ssoLoginUrl,
          serviceConfiguration: _serviceConfiguration,
          clientSecret: RemoteConfig.ssoSecret,
          scopes: [
            'openid',
            'profile',
            'offline_access',
            'EmployeeAdminstration.Api',

          ],

          // fawzi add extra pram to login
          //  additionalParameters: {"appId":"BaladySuperApp","fcmToken":CommonProperties.fcmToken!,"deviceId":CommonProperties.deviceId!}
        ),
      );
      response?.accessToken.actionLog();
      return response!;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
      );
    }
  }

  @override
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      TokenResponse? response = await _appAuth.token(
        TokenRequest(
          RemoteConfig.ssoClient,
          RemoteConfig.ssoLoginUrl,
          serviceConfiguration: _serviceConfiguration,
          refreshToken: refreshToken,
          clientSecret: RemoteConfig.ssoSecret,
          scopes: [
            'openid',
            'profile',
            'offline_access',
          ],
        ),
      );

      return response!;
    } on PlatformException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error.toString().contains("invalid_grant")) {
        sl<EntryPointCubit>().autoLogout();
      }
      throw ServerException(
        "",
      );
    }
  }

  @override
  Future<SsoUserInfoModel?> getSSOProfile() async {
    Response? response;
    try {
      response = await webServiceSSo.dio.get(ApiUrl.ssoUserInfo,
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data;

      var parsedResult = data != null ? SsoUserInfoModel.fromJson(data) : null;

      return parsedResult.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<String> logout() async {
    Response? response;

    try {
      response = await webService.dio.get(
        "${RemoteConfig.ssoUrl}/connect/endsession",
        queryParameters: {
          "id_token_hint": sl<EntryPointCubit>().state.token?.idToken,
          "post_logout_redirect_uri": RemoteConfig.ssoLogOutUrl
        },
      );

      // var data = response.data["data"]?["result"];

      // var parsedResult = data != null ? data : null;
      // final decodedResponse =
      //    ApigeeResponseModel<UpdateDeviceResponseModel>.fromMap(response.data,
      //        parsedResult: parsedResult);
      return response.data;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ForceUpdateResponseModel> getForceVersion(
      {required ForceUpdateParams params}) async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.forceUpdate,
        queryParameters: {
          ApiParam.type.name: params.type,
          ApiParam.appID.name: params.appId,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ForceUpdateResponseModel.fromMap(data) : null;

      //final decodedResponse =
      //  ApigeeResponseModel<ForceUpdateResponseModel>.fromMap(response.data,
      //    parsedResult: parsedResult);
      return parsedResult!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<EndSessionResponse> endSession() async {
    try {
      EndSessionResponse? response = await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: sl<EntryPointCubit>().state.token?.idToken,
          serviceConfiguration: _serviceConfiguration,
        ),
      );

      return response!;
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
    Response? response;
    try {
      response = await webServiceSSo.dio.get(ApiUrl.ssoUserCookie,
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      String? cookie;
      if (response.headers['set-cookie']?.toString() != null) {
        cookie = response.headers['set-cookie'].toString();
      }

      return cookie;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeTokenResponse> getAPIgeeToken() async {
    Response? response;
    try {
      String username = RemoteConfig.apigeeUsername;
      String password = RemoteConfig.apigeePassword;
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      response = await webService.dio.post(ApiUrl.apigeeToken,
          options: Options(
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": basicAuth
            },
          ),
          data: {"grant_type": "client_credentials"});

      ApigeeTokenResponseModel apigeeResponse =
          ApigeeTokenResponseModel.fromMap(response.data);
      return apigeeResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future getDataTest() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.dashboardCards,
      );

      var data = response.data;
      data.toString().successLog();

      /*  final result =
          ApigeeResponseModel<List<TestModel>>.fromMap(data).data?.result;
   
      List<TestModel>? d = result != null
          ? List<TestModel>.from(result.map((x) => TestModel.fromMap(x)))
          : null;

 ;*/

      final result = ResponseBodyModel.fromMap(data).data?.result;
      List<TestModel>? d = result != null
          ? List<TestModel>.from(result.map((x) => TestModel.fromMap(x)))
          : null;

      return result.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      error.errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      error.errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<PermissionResponseModel> getEkramRules(
      {required GetPermissionParamsModel params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.ekramRules,
        data: params.toMap(),
      );
      print(response.data["data"]);
      var data = response.data["data"]?["result"];
      var parsedResult =
          data != null ? PermissionResponseModel.fromMap(data) : null;

      return parsedResult!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<String> getPaymentURL({required PaymentRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.paymentURL,
        data: params.toMap(),
      );
      print(response);
      print(response.data["data"]);
      return response.data["data"]?["result"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}
