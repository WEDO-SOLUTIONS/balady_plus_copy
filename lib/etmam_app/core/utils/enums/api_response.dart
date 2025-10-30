import 'package:dio/dio.dart' show Response;
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    hide Response;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../utils_exports.dart' show Log, ResponseDataInMapFormat;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

enum ApiResponse {
  //? First solution, "In case of messages is static"
  // but when you access message, you need to translate it
  deadlineExceeded(message: "errorConnectionTimeoutWord"),
  badRequest(message: "errorBadRequestWord"),
  unAuthorized(message: "errorUnAuthorizedUserWord"),
  requestNotFound(message: "errorRequestNotFoundWord"),
  methodNotAllowed(message: "errorMethodNotAllowedWord"),
  conflict(message: "errorConflictWord"),
  internalServerError(message: "errorInternalServerErrorWord"),
  noInternetConnection(message: "errorNoInternetConnectionWord");

  const ApiResponse({required this.message});
  final String message;

  //? Second solution "In case of messages returned from Server"
  String getErrorMessage([Response? response]) {
    final serverErrorMessage = _handleServerErrorMessage(response);
    "Server-Error-Message: $serverErrorMessage".errorLog();
    switch (this) {
      case ApiResponse.deadlineExceeded:
        return "errorConnectionTimeout".tr();
      /* case ApiResponse.badRequest:
        return serverErrorMessage ?? "errorBadRequestWord".tr();*/
      case ApiResponse.unAuthorized:
        return serverErrorMessage ?? "errorUnAuthorizedUser".tr();
      case ApiResponse.requestNotFound:
        return serverErrorMessage ?? "errorRequestNotFoundWord".tr();
      /*case ApiResponse.methodNotAllowed:
        return serverErrorMessage ?? "errorMethodNotAllowedWord".tr();
      case ApiResponse.conflict:
        return serverErrorMessage ?? "errorConflict".tr();*/
      case ApiResponse.internalServerError:
        return "errorInternalServerError".tr();
      case ApiResponse.noInternetConnection:
        return "errorNoInternetConnection".tr();

      default:
        return serverErrorMessage ?? "errors_server_error_1".tr();
    }
  }

  String? _handleServerErrorMessage(Response? response) {
    String? message;
    print("handle error msg ${response?.data}");
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
      message =
          m?.data?.getRefResponseMessage() ?? trans("errors_server_error_1");
    }
    return message;
  }

  String? _checkErrorMessage(ResponseDataInMapFormat response) {
    String? message;
    if (response["Message"] != null && response["Message"].isNotEmpty) {
      message = response['Message'];
      if (message!.contains("Invalid user name or password")) {
        message = "errorInvalidCredentialsWord".tr();
      }
    }
    return message;
  }
}
