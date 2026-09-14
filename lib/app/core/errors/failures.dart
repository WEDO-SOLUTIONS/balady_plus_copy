import 'package:equatable/equatable.dart' show Equatable;

import '../utils/utils_exports.dart' show APIResponsesConversion, ApiResponse;

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <Object?>[]]);

  @override
  List<Object?> get props => properties;
}

// Global Failures
class ServerFailure extends Failure {
  final String errorMessage;
  final int? statusCode;
  final dynamic errorCode;
  ServerFailure(this.errorMessage, {this.statusCode, this.errorCode}) : super([errorMessage, statusCode, errorCode]);

  @override
  String toString() => errorMessage;
}

class CacheFailure extends Failure {}

class AuthNotFoundedFailure extends Failure {}

class CannotPrintBillFailure extends Failure {}

class NoDataFoundFailure extends Failure {}

class NoInternetConnectionFailure extends Failure {
  @override
  String toString() => ApiResponse.noInternetConnection.getErrorMessage();
}
