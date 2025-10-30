import 'package:dio/dio.dart' show DioError, RequestOptions, Response;

import '../utils/utils_exports.dart' show APIResponsesConversion, ApiResponse;

// Global Exceptions
class ServerException implements Exception {
  final String errorMessage;
  final int? statusCode;
  final String? statusMessage;
  final String? errorCode;

  const ServerException(this.errorMessage,
      {this.statusCode, this.statusMessage, this.errorCode});
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

//! Tokens Exceptions
class TokenNotFoundException extends DioError {
  TokenNotFoundException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.tokenNotFound.getErrorMessage(response);
}

class FailedToGenerateTokenException extends DioError {
  FailedToGenerateTokenException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() =>
      ApiResponse.failedToGenerateToken.getErrorMessage(response);
}

class TokenHasExpiredException extends DioError {
  TokenHasExpiredException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.tokenHasExpired.getErrorMessage(response);
}
