import 'package:dio/dio.dart' show Response;
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../features/_shared_feature_/data/models/apigee_response_model.dart';
import '../utils_exports.dart' show ApiResponse, Log;

import 'package:balady_plus/app/events_logs/balady_logs.dart';

extension APIResponsesConversion on ApiResponse {
  String getErrorMessage([Response? response]) {
    final serverErrorMessage = _handleServerErrorMessage(response);
    "Server-Error-Message: $serverErrorMessage".errorLog();
    switch (this) {
      case ApiResponse.deadlineExceeded:
        return "errorConnectionTimeout".tr();
      case ApiResponse.badRequest:
        return serverErrorMessage ?? "errorBadRequest".tr();
      case ApiResponse.unAuthorized:
        return serverErrorMessage ?? "errorUnAuthorizedUser".tr();
      case ApiResponse.requestNotFound:
        return serverErrorMessage ?? "errorRequestNotFound".tr();
      case ApiResponse.methodNotAllowed:
        return serverErrorMessage ?? "errorMethodNotAllowed".tr();
      case ApiResponse.conflict:
        return serverErrorMessage ?? "errorConflict".tr();
      case ApiResponse.internalServerError:
        return serverErrorMessage ?? "errorInternalServerError".tr();
      // return "errorInternalServerError".tr();
      case ApiResponse.noInternetConnection:
        return "errorNoInternetConnection".tr();
      case ApiResponse.tokenNotFound:
        return "Token not founded";
      case ApiResponse.failedToGenerateToken:
        return "Failed to generate token";
      case ApiResponse.tokenHasExpired:
        return "Token has been expired";
    }
  }

  String? _handleServerErrorMessage(Response? response) {
    String? message;
    if (response != null && response.data != null) {
      ApigeeResponseModel? m;
      try {
        m = ApigeeResponseModel.fromMap(response.data);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
      message = m?.data?.getRefResponseMessage() ?? ("errors_server_error_1").tr();
    }
    return message;
  }
}
