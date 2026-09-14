import 'package:dio/dio.dart' show DioException, RequestOptions, Response;

import '../utils/utils_exports.dart' show APIResponsesConversion, ApiResponse;

// Global Exceptions
class ServerException implements Exception {
  final String errorMessage;
  final int? statusCode;
  final String? statusMessage;
  final DioException? dioError;
  final Response? response;
  final dynamic errorCode;
  final Exception? exception;

  ServerException(
    this.errorMessage, {
    this.statusCode,
    this.statusMessage,
    this.dioError,
    this.response,
    this.errorCode,
    this.exception,
  }) {
    // CommonFunctions.sendEvent(
    //     dioError: dioError,
    //     response: response,
    //     ex: exception,
    //     errorMessage: errorMessage);
  }
}

class APIException implements Exception {
  final String? errorMessage;

  APIException({this.errorMessage});
}

class CacheException implements Exception {}

class CannotGoToSystemException implements Exception {}

class AuthNotFoundedException implements Exception {}

class CannotPrintBillException implements Exception {}

class CannotDrawAppBarTitleWidgetException implements Exception {}

/* ------------ Web Services Exceptions ------------ */
class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions requestOptions) : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.deadlineExceeded.getErrorMessage(response);
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  // String toString() => ApiResponseI.badRequest.getErrorMessage(response);
  String toString() => ApiResponse.badRequest.getErrorMessage(response);
}

class NoDataFoundException extends DioException {
  NoDataFoundException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);
  @override
  String toString() => ApiResponse.unAuthorized.getErrorMessage(response);
}

class UnAuthorizedException extends DioException {
  UnAuthorizedException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.unAuthorized.getErrorMessage(response);
}

class RequestNotFoundException extends DioException {
  RequestNotFoundException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.requestNotFound.getErrorMessage(response);
}

class MethodNotAllowedException extends DioException {
  MethodNotAllowedException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.methodNotAllowed.getErrorMessage(response);
}

class ConflictException extends DioException {
  ConflictException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.conflict.getErrorMessage(response);
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions requestOptions, Response? response)
    : super(requestOptions: requestOptions, response: response);

  @override
  String toString() => ApiResponse.internalServerError.getErrorMessage(response);
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions requestOptions) : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.noInternetConnection.getErrorMessage(response);
}

//! Tokens Exceptions
class TokenNotFoundException extends DioException {
  TokenNotFoundException(RequestOptions requestOptions) : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.tokenNotFound.getErrorMessage(response);
}

class FailedToGenerateTokenException extends DioException {
  FailedToGenerateTokenException(RequestOptions requestOptions) : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.failedToGenerateToken.getErrorMessage(response);
}

class TokenHasExpiredException extends DioException {
  TokenHasExpiredException(RequestOptions requestOptions) : super(requestOptions: requestOptions);

  @override
  String toString() => ApiResponse.tokenHasExpired.getErrorMessage(response);
}
