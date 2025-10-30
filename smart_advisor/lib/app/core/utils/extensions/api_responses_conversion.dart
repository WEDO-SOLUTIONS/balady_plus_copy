import 'package:dio/dio.dart' show Response;
import 'package:smart_advisor/app/features/_shared_feature_/presentation/models/response_body_model.dart';
import '/app/core/utils/constants/language.dart';

import '../utils_exports.dart' show ApiResponse, Log, ResponseDataInMapFormat;

extension APIResponsesConversion on ApiResponse {
  String getErrorMessage([Response? response]) {
    final serverErrorMessage = _handleServerErrorMessage(response);
    print(serverErrorMessage);
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
      ResponseBodyModel? m;
      try {
        m = ResponseBodyModel.fromMap(response.data);
      } catch (error, stackTrace) {
        /* LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );*/
      }
      message =
          m?.data?.getRefResponseMessage() ?? ("errors_server_error_1").tr();
    }
    return message;
  }
}
