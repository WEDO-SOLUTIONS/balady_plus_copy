import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;

import '../../errors/errors_exports.dart'
    show
        BadRequestException,
        ConflictException,
        DeadlineExceededException,
        InternalServerErrorException,
        MethodNotAllowedException,
        NoInternetConnectionException,
        RequestNotFoundException,
        UnAuthorizedException;
import '../../utils/utils_exports.dart' show EnvType, Log;
import '../services_exports.dart' show SmartAdvisorNetworkConnection;
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';

// Please using any technique to create singleton WebService (GetIt)
class SmartAdvisorWebService {
  final Dio dio;

  SmartAdvisorWebService({required this.dio}) {
    dio.options.baseUrl = sl<EnvType>().domain;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {"Accept-Language": "ar"};
    dio.options.headers = {"lang": "ar"};
    dio.interceptors.add(AppInterceptors());

    // avoid using it in production or do it at your own risks!
    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
  }
}

class AppInterceptors extends Interceptor {
  late SmartAdvisorNetworkConnection smartAdvisorNetworkConnection;

  AppInterceptors() {
    smartAdvisorNetworkConnection = sl<SmartAdvisorNetworkConnection>();
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    "On-Sending-Request ${options.uri}".actionLog();

    if (await smartAdvisorNetworkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();

    switch (err.type) {
      case DioErrorType.sendTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            throw UnAuthorizedException(err.requestOptions, err.response);
          case 404:
            throw RequestNotFoundException(err.requestOptions, err.response);
          case 405:
            throw MethodNotAllowedException(err.requestOptions, err.response);
          case 409:
            throw ConflictException(err.requestOptions, err.response);
          case 500:
            throw InternalServerErrorException(
              err.requestOptions,
              err.response,
            );
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
      // TODO: Handle this case.
      case DioExceptionType.connectionTimeout:
      // TODO: Handle this case.
      case DioExceptionType.badCertificate:
      // TODO: Handle this case.
      case DioExceptionType.connectionError:
      // TODO: Handle this case.
    }

    return handler.next(err);
  }
}
