import 'package:dio/dio.dart' show Response;
import '/app/core/utils/constants/language.dart';

import '../utils_exports.dart' show ApiResponse, Log, ResponseDataInMapFormat;

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
    if (response != null &&
        response.data != null &&
        response.data is ResponseDataInMapFormat) {
      message = _checkErrorMessage(response.data);
    }
    return message;
  }

  String? _checkErrorMessage(ResponseDataInMapFormat response) {
    String? message;
    if (response["Message"] != null && response["Message"].isNotEmpty) {
      message = response['Message'];
      if (message!.contains("Invalid user name or password")) {
        message = "errorInvalidCredentials".tr();
      }
    }
    return message;
  }
}
