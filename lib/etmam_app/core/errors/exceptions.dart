import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart' show DioError, RequestOptions, Response;

import '../utils/utils_exports.dart' show ApiResponse;

// Global Exceptions
class ServerException implements Exception {
  final String errorMessage;
  final int? statusCode;
  final String? statusMessage;
  final DioError? dioError;
  final Response? response;
  final dynamic errorCode;
  final Exception? exception;

  ServerException(this.errorMessage,
      {this.statusCode,
      this.statusMessage,
      this.dioError,
      this.response,
      this.errorCode,
      this.exception}) {
    // CommonFunctions.sendEvent(
    //     dioError: dioError, response: response, ex: exception);
  }
}

class APIException implements Exception {
  final String? errorMessage;

  APIException({
    this.errorMessage,
  }) {}
}

class ServerError implements Exception {
  final String errorMessage;
  final int? statusCode;
  final String? statusMessage;

  const ServerError(
    this.errorMessage, {
    this.statusCode,
    this.statusMessage,
  });
}

class CacheException implements Exception {}

class CannotGoToSystemException implements Exception {}

class AuthNotFoundedException implements Exception {}

class CannotPrintBillException implements Exception {}

class CannotDrawAppBarTitleWidgetException implements Exception {}

/* ------------ Web Services Exceptions ------------ */
class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.deadlineExceeded.getErrorMessage(response);
}

class BadRequestException extends DioError {
  BadRequestException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.badRequest.getErrorMessage(response);
}

class UnAuthorizedException extends DioError {
  UnAuthorizedException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.unAuthorized.getErrorMessage(response);
}

class RequestNotFoundException extends DioError {
  RequestNotFoundException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.requestNotFound.getErrorMessage(response);
}

class MethodNotAllowedException extends DioError {
  MethodNotAllowedException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.methodNotAllowed.getErrorMessage(response);
}

class ConflictException extends DioError {
  ConflictException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.conflict.getErrorMessage(response);
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(
    RequestOptions requestOptions,
    Response? response,
  ) : super(requestOptions: requestOptions, response: response);

  @override
  String toString() =>
      ApiResponse.internalServerError.getErrorMessage(response);
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() =>
      ApiResponse.noInternetConnection.getErrorMessage(response);
}
