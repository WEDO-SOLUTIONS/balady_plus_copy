import 'dart:convert';

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
import '../../utils/utils_exports.dart' show CommonFunctions, EnvType, Log;
import '../services_exports.dart' show SmartAdvisorNetworkConnection;
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

// Please using any technique to create singleton WebService (GetIt)
class SmartAdvisorWebService {
  final Dio dio;

  SmartAdvisorWebService({required this.dio}) {
    dio.options.baseUrl = sl<EnvType>().domain;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {
      "Accept-Language": "ar",
      "x-platform-id": "smart-advisor",
      "x-channel-id": "mobile",
    };

    //dio.options.headers = {"lang": "ar"};
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
    bool isAuth = false;
    "On-Sending-Request ${options.uri}".actionLog();
    if (options.uri.path.contains("ext/") ||
        options.uri.path.contains("delegation-services") ||
        options.uri.path.contains("commercial/licenses") ||
        options.uri.path.contains("license-details")) {
      isAuth = true;
      options.headers
          .addAll({"Authorization": "Bearer ${BaladyServices.token}"});
    }

    if (await smartAdvisorNetworkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    String url = options.uri.toString();
    url = Uri.decodeQueryComponent(url);

    if (!options.headers.containsKey("verifyingKEY")) {
      final method = options.method;
      final verifyingKEY = CommonFunctions.hashRequest(
        url, method,
        authorization: isAuth,
        body: (options.data != null ? options.data.toString() : null),
        // authorization: BaladyServices.token.isNotEmpty ? true : false
      );
      options.headers.putIfAbsent("verifyingKEY", () => verifyingKEY);
    }

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("HHGGGGGGGGGGG");
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();
    print(err.type);
    switch (err.type) {
      case DioErrorType.sendTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.badResponse:
        throw BadRequestException(err.requestOptions, err.response);

      case DioErrorType.cancel:
        break;
      case DioErrorType.unknown:
        throw BadRequestException(err.requestOptions, err.response);
      //   throw NoInternetConnectionException(err.requestOptions);
      // TODO: Handle this case.
      case DioExceptionType.connectionTimeout:
        throw BadRequestException(err.requestOptions, err.response);
      // TODO: Handle this case.
      case DioExceptionType.badCertificate:
        throw BadRequestException(err.requestOptions, err.response);
      // TODO: Handle this case.
      case DioExceptionType.connectionError:
        throw BadRequestException(err.requestOptions, err.response);
      // TODO: Handle this case.
    }

    return handler.next(err);
  }
}
