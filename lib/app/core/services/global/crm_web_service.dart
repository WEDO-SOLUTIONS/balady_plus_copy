import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthData, AuthDataModel;
import '../../../features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../errors/errors_exports.dart'
    show
        BadRequestException,
        ConflictException,
        DeadlineExceededException,
        FailedToGenerateTokenException,
        InternalServerErrorException,
        MethodNotAllowedException,
        NoDataFoundException,
        NoInternetConnectionException,
        RequestNotFoundException,
        TokenHasExpiredException,
        TokenNotFoundException,
        UnAuthorizedException;
import '../../utils/utils_exports.dart'
    show
        ApiHeader,
        ApiPOST,
        ApiParam,
        CommonFunctions,
        CommonProperties,
        EnvType,
        Log,
        WithDelay;
import '../services_exports.dart' show AppCertificatePinningInterceptor, NavigationService, NetworkConnection;

// Please using any technique to create singleton WebService (GetIt)
class CRMWebService {
  final Dio dio;

  CRMWebService({required this.dio}) {
    dio.options.baseUrl = RemoteConfig.pegaURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    dio.addSentry();
    dio.interceptors.add(AppInterceptors());

    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
   dio.interceptors.add(
       AppCertificatePinningInterceptor(allowedSHAFingerprints: CommonProperties.allowedSHAFingerprints,callFollowingErrorInterceptor: true)
    );
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
    ));
  }
  CRMWebService.newDio({
    required this.dio,
  });
}

class AppInterceptors extends Interceptor {
  late NetworkConnection networkConnection;

  AppInterceptors() {
    networkConnection = sl<NetworkConnection>();
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    "On-Sending-Request ${options.uri}".actionLog();
    // Update language
    options.headers[ApiHeader.language.eName] = languageCode;
    options.headers["Accept-Language"] = languageCode;

    if (await networkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    String url = options.uri.toString();
    final method = options.method;

    if (options.headers['Authorization'] == null &&
        CommonProperties.isLoggedIn &&
        !options.uri.toString().contains("bcg/upload-file")) {
      options.headers['Authorization'] = 'Bearer ${CommonProperties.token}';
    }

    if (url.contains("damaged-vehicle-mobile/car-models")) {
      url = options.baseUrl + options.path;
      url += "?CompanyID=${options.queryParameters["CompanyID"]}";
    }

    final verifyingKEY = CommonFunctions.hashRequest(url, method,
        body: (options.data != null &&
                !options.uri.toString().contains("bcg/upload-file"))
            ? json.encode(options.data)
            : null,
        authorization: !options.uri.toString().contains("bcg/upload-file")
            ? options.headers.containsKey("Authorization")
            : false);
    options.headers
        .putIfAbsent(ApiHeader.verifyingKEY.name, () => verifyingKEY);
    options.headers.putIfAbsent("x-channel-id", () => "MOBILE");
    options.headers.putIfAbsent(
        'Cookie', () => sl<EntryPointCubit>().state.token?.appCookie ?? "");

    //if (options.headers['Authorization'] == null) {
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();

    switch (err.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            if (err.response?.data['data']?['responseCode'] == '2') {
              throw NoDataFoundException(err.requestOptions, err.response);
            }
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            sl<EntryPointCubit>().autoLogout();
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
          default:
            throw BadRequestException(err.requestOptions, err.response);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.badCertificate:
        throw NoInternetConnectionException(err.requestOptions);
        break;
      case DioErrorType.connectionError:
        throw NoInternetConnectionException(err.requestOptions);
        break;
      case DioErrorType.unknown:
        throw BadRequestException(err.requestOptions, err.response);

      default:
        throw BadRequestException(err.requestOptions, err.response);
    }
    throw BadRequestException(err.requestOptions, err.response);

    return handler.next(err);
  }

  String get languageCode => translator.activeLanguageCode;
  bool get mounted => true;
}
