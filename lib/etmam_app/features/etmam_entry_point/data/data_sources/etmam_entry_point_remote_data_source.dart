import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponseModel;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/data/models/profile_model.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class AuthRemoteDataSource {
  Future<ApigeeResponseModel<ProfileModel>> getProfile();
  Future<ApigeeResponseModel<String>> createProfile();
  Future<ApigeeResponseModel> updateProfile(
      {required UpdateProfileParams params});

  Future<ApigeeResponseModel<AddDeviceResponseModel>> addDeviceToken(
      {required AddDeviceParams params});

  Future<ApigeeResponseModel<UpdateDeviceResponseModel>> updateDeviceToken(
      {required UpdateDeviceParams params});

  Future<ForceUpdateResponseModel> getForceVersion(
      {required ForceUpdateParams params});
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final WebService webService;

  AuthRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponseModel<ProfileModel>> getProfile() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.defaultProfile,
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? ProfileModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<ProfileModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
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
      if (error is ServerException)
        throw error;
      else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeResponseModel<String>> createProfile() async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.createProfile,
          data: {
            ApiParams.cityId: CommonProperties.cityId,
            ApiParams.langId: "ar",
            ApiParams.name: "Main Profile",
            ApiParams.typeId: "main",
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? data : null;
      final decodedResponse = ApigeeResponseModel<String>.fromMap(response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
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
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeResponseModel> updateProfile(
      {required UpdateProfileParams params}) async {
    var response;

    try {
      response = await webService.dio.put(
          ApiUrl.updateProfile + CommonProperties.profileId!,
          data: {
            ApiParams.cityId: params.cityId,
            ApiParams.langId: "ar",
            ApiParams.name: "Main Profile",
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? data : null;
      final decodedResponse = ApigeeResponseModel.fromMap(response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
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
      if (error is ServerException)
        throw error;
      else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeResponseModel<AddDeviceResponseModel>> addDeviceToken(
      {required AddDeviceParams params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.addDeviceToken,
          data: {
            ApiParams.id: params.id,
            ApiParams.name: params.name,
            ApiParams.notificationToken: params.notificationToken,
            ApiParams.os: params.os,
            ApiParams.typeId: params.typeId,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? data : null;
      final decodedResponse =
          ApigeeResponseModel<AddDeviceResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
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
      if (error is ServerException)
        throw error;
      else {
        try {
          ///  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeResponseModel<UpdateDeviceResponseModel>> updateDeviceToken(
      {required UpdateDeviceParams params}) async {
    var response;

    try {
      response = await webService.dio.put(
          ApiUrl.updateDeviceToken + (params.id ?? ""),
          data: {
            ApiParams.name: params.name,
            ApiParams.notificationToken: params.notificationToken,
            ApiParams.os: params.os,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null ? data : null;
      final decodedResponse =
          ApigeeResponseModel<UpdateDeviceResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
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
      if (error is ServerException)
        throw error;
      else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
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
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.forceUpdate,
        queryParameters: {
          ApiParams.type: params.type,
          ApiParams.appID: params.appId,
        },
      );

      var data = response.data["data"]?["result"];
      //print("GGSSSSSS ${data}");
      var parsedResult =
          data != null ? ForceUpdateResponseModel.fromMap(data) : null;
      //print("GGSSSSSS ${parsedResult?.versionNumber}");

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
      //print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
